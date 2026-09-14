clear all;
clc;

imagemOriginalLena = imread('lenaRGB.png');
imgR = imagemOriginalLena(:, :, 1);
imgG = imagemOriginalLena(:, :, 2);
imgB = imagemOriginalLena(:, :, 3);

[M, N] = size(imgR);

mensagemOculta = imread('mensagem.bmp');
mensagemOculta = imresize(mensagemOculta, [M, N]);

imgComMensagemR = imgR;

for i = 1:M
    for j = 1:N
        imgComMensagemR(i, j) = bitset(imgR(i, j), 1, mensagemOculta(i, j));
    end
end

imgJunto = cat(3, imgComMensagemR, imgG, imgB);
imwrite(imgJunto, 'marcadaAulaColorida.bmp');

msgExtraida = zeros(M, N);
for i = 1:M
    for j = 1:N
        msgExtraida(i, j) = bitget(imgComMensagemR(i, j), 1);
    end
end

imgAdulterada = imgJunto;
imgAdulterada(100:200, 100:200, :) = 255; % Risca um quadrado branco
imwrite(imgAdulterada, 'marcadaAdulterada.bmp');

msgExtraidaAdulterada = zeros(M, N);
imgAdulteradaR = imgAdulterada(:, :, 1);
for i = 1:M
    for j = 1:N
        msgExtraidaAdulterada(i, j) = bitget(imgAdulteradaR(i, j), 1);
    end
end

subplot(2, 3, 1); imshow(imagemOriginalLena); title('Imagem Original');
subplot(2, 3, 2); imshow(mensagemOculta); title('Mensagem Original');
subplot(2, 3, 3); imshow(imgJunto); title('Imagem Marcada');
subplot(2, 3, 4); imshow(msgExtraida); title('Mensagem Extraída');
subplot(2, 3, 5); imshow(imgAdulterada); title('Imagem Adulterada');
subplot(2, 3, 6); imshow(msgExtraidaAdulterada); title('Msg Pós-Adulteração');