function [acertos, respostas, preenchimento] = corrigirGabarito(arquivo, gabarito, debug)
%CORRIGIRGABARITO Le uma folha de respostas e conta quantas questoes estao certas.
%
%   [acertos, respostas] = corrigirGabarito(arquivo, gabarito)
%
%   arquivo  - caminho da imagem da folha (RGB, com a moldura verde)
%   gabarito - string de 8 letras com as respostas corretas, ex: 'ADBCADBC'
%   debug    - (opcional) true mostra a grade sobreposta na imagem
%
%   Retorna o numero de acertos, as respostas lidas ('-' = em branco,
%   '*' = dupla marcacao) e a matriz 8x4 com a fracao de tinta de cada celula.
%
%   Exemplo:
%       [n, r] = corrigirGabarito('folha_foto.png', 'ADBCADBC', true)

    if nargin < 2 || isempty(gabarito)
        gabarito = 'ADBCADBC';   % <-- TROQUE pelo gabarito real da prova
    end
    if nargin < 3
        debug = false;
    end

    NQ = 8;              % questoes
    NA = 4;              % alternativas por questao
    LETRAS = 'ABCD';

    % Dois limiares, nao um. Sao perguntas diferentes:
    LIMIAR_MARCA  = 0.40;  % "isto e uma alternativa marcada" -> define a letra
    LIMIAR_RASURA = 0.20;  % "aqui tem alguma tinta"          -> detecta rasura
    RECORTE     = 0.25;  % quanto encolher cada celula (tira o contorno preto)
    MARGEM      = 8;     % pixels descartados pra dentro da moldura verde
    FATOR_TINTA = 0.70;  % pixel e tinta se estiver abaixo de 70% do fundo
    PISO_VERDE  = 12;    % dominancia minima do canal verde

    %% 1) Leitura
    I = imread(arquivo);
    if size(I, 3) ~= 3
        error('corrigirGabarito:naoRGB', ...
              'A imagem precisa ser RGB - a moldura verde e usada como referencia.');
    end

    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,3));

    %% 2) Segmentacao da moldura verde
    % Mede a DOMINANCIA do canal verde, nao seu valor absoluto: assim o
    % metodo funciona tanto no verde vivo do arquivo digital quanto no verde
    % lavado de uma folha impressa e fotografada.
    dominancia = G - max(R, B);

    % Limiar adaptativo. Um valor fixo quebra: no arquivo digital o verde tem
    % dominancia ~48, numa foto JPEG da mesma folha cai pra ~24, e as bordas
    % da linha ficam ainda mais baixas por causa da compressao.
    limiarVerde = max(PISO_VERDE, 0.5 * max(dominancia(:)));
    verde = dominancia > limiarVerde;

    verde = bwareaopen(verde, 50);      % descarta ruido isolado
    if ~any(verde(:))
        error('corrigirGabarito:semMoldura', ...
              'Moldura verde nao encontrada em %s.', arquivo);
    end
    verde = bwareafilt(verde, 1);       % so o maior componente = a moldura

    [lin, col] = find(verde);
    y0 = min(lin) + MARGEM;   y1 = max(lin) - MARGEM;
    x0 = min(col) + MARGEM;   x1 = max(col) - MARGEM;

    if y1 - y0 < NQ * 10 || x1 - x0 < NA * 10
        error('corrigirGabarito:molduraPequena', ...
              ['A regiao verde detectada e pequena demais (%dx%d px). ', ...
               'Provavelmente foi ruido, nao a moldura.'], x1-x0, y1-y0);
    end

    area = I(y0:y1, x0:x1, :);

    %% 3) Binarizacao: tinta vira 1, fundo vira 0
    % NAO usar Otsu aqui. Otsu separa DUAS classes, mas a folha tem TRES:
    % fundo claro, traco preto do quadradinho e tinta colorida da caneta.
    % Com caneta azul (RGB 63,72,204 -> cinza 84) o Otsu corta exatamente em
    % cima da marca e ela desaparece. O limiar relativo ao fundo resolve isso
    % e ainda tolera iluminacao ruim, porque o fundo e medido na propria folha.
    cinza = double(im2gray(area));
    ordenado = sort(cinza(:));
    fundo = ordenado(round(0.75 * numel(ordenado)));   % percentil 75 = fundo
    bw = cinza < FATOR_TINTA * fundo;

    %% 4) Varredura da grade 8x4
    [altura, largura] = size(bw);
    hCelula = altura  / NQ;
    wCelula = largura / NA;

    preenchimento = zeros(NQ, NA);

    for i = 1:NQ
        for j = 1:NA
            % encolhe a celula pra excluir o contorno preto do quadradinho
            l1 = round((i-1)*hCelula + RECORTE*hCelula) + 1;
            l2 = round( i   *hCelula - RECORTE*hCelula);
            c1 = round((j-1)*wCelula + RECORTE*wCelula) + 1;
            c2 = round( j   *wCelula - RECORTE*wCelula);

            miolo = bw(l1:l2, c1:c2);
            preenchimento(i,j) = mean(miolo(:));
        end
    end

    %% 5) Decisao por questao
    respostas = repmat('-', 1, NQ);

    for i = 1:NQ
        linha    = preenchimento(i,:);
        comTinta = find(linha > LIMIAR_RASURA);   % qualquer intervencao
        marcadas = find(linha > LIMIAR_MARCA);    % marcacao de verdade

        if numel(comTinta) > 1
            % Mexeu em mais de uma alternativa: anula, mesmo que uma delas
            % esteja muito mais preenchida que as outras. Nao cabe ao
            % corretor adivinhar a intencao de quem rasurou.
            respostas(i) = '*';
        elseif numel(marcadas) == 1
            respostas(i) = LETRAS(marcadas);
        else
            respostas(i) = '-';      % em branco ou marcacao fraca demais
        end
    end

    %% 6) Comparacao com o gabarito
    acertos = sum(respostas == upper(gabarito));

    fprintf('\n--- Correcao: %s ---\n', arquivo);
    for i = 1:NQ
        if respostas(i) == gabarito(i)
            situacao = 'OK';
        elseif respostas(i) == '-'
            situacao = 'em branco';
        elseif respostas(i) == '*'
            situacao = 'anulada';
        else
            situacao = 'errou';
        end
        fprintf('  Q%d: marcou %c | gabarito %c  (%-9s)  A=%.2f B=%.2f C=%.2f D=%.2f\n', ...
                i, respostas(i), gabarito(i), situacao, preenchimento(i,:));
    end
    fprintf('  Total: %d/%d acertos\n\n', acertos, NQ);

    %% 7) Visualizacao opcional
    if debug
        figure('Name', 'Grade detectada');
        imshow(area); hold on;
        for i = 0:NQ
            plot([1 largura], [i*hCelula i*hCelula], 'r-', 'LineWidth', 1);
        end
        for j = 0:NA
            plot([j*wCelula j*wCelula], [1 altura], 'r-', 'LineWidth', 1);
        end
        for i = 1:NQ
            for j = 1:NA
                if preenchimento(i,j) > LIMIAR_MARCA
                    cor = 'g';                  % marcacao
                elseif preenchimento(i,j) > LIMIAR_RASURA
                    cor = [1 0.5 0];            % rasura: tinta fraca
                else
                    cor = 'y';                  % vazia
                end
                text((j-0.5)*wCelula, (i-0.5)*hCelula, ...
                     sprintf('%.2f', preenchimento(i,j)), ...
                     'Color', cor, 'HorizontalAlignment', 'center', ...
                     'FontWeight', 'bold', 'FontSize', 9);
            end
        end
        title(sprintf(['Grade detectada - verde = marcada (>%.2f), ' ...
                       'laranja = rasura (>%.2f)'], LIMIAR_MARCA, LIMIAR_RASURA));
        hold off;
    end
end
