# Leitor automático de gabarito

Correção automática de folhas de resposta por processamento de imagem, em MATLAB.

Disciplina: Tópicos em Tecnologia da Informação — Prof. Ivan Oliveira Lopes

## O problema

Ler a folha de respostas de uma prova de 8 questões com 4 alternativas cada (A–D)
e informar quantas questões foram respondidas corretamente.

## Como usar

```matlab
[acertos, respostas] = corrigirGabarito('folha_foto.jpg', 'ADBCADBC', true);
```

| Parâmetro | Descrição |
|---|---|
| `arquivo` | caminho da imagem da folha (precisa ser RGB) |
| `gabarito` | string de 8 letras com as respostas corretas |
| `debug` | opcional; `true` abre a figura com a grade sobreposta |

Retorno:

- `acertos` — número de questões certas
- `respostas` — string de 8 caracteres: a letra marcada, `-` para em branco, `*` para anulada
- `preenchimento` — matriz 8×4 com a fração de tinta de cada célula

## Como funciona

O método usa a **moldura verde** que delimita a área de respostas como referência
geométrica. Isso dispensa coordenadas fixas e faz o código funcionar em qualquer
resolução de imagem.

1. **Segmentação da moldura** — mede a dominância do canal verde (`G - max(R,B)`)
   em vez do valor absoluto, e aplica limiar adaptativo. O maior componente
   conectado é a moldura; seu *bounding box* define a região de interesse.
2. **Binarização** — limiar relativo ao nível de fundo da própria folha,
   medido pelo percentil 75 da região recortada.
3. **Grade** — a região é dividida em 8×4 por divisão aritmética. Cada célula é
   encolhida 25% para excluir o contorno preto do quadradinho.
4. **Medição** — a fração de pixels de tinta no miolo de cada célula.
5. **Decisão** — dois limiares: 0,40 define a alternativa marcada, 0,20 detecta
   qualquer intervenção (rasura, letra escrita à mão).

## Decisões de projeto

### Por que não usar Otsu na binarização

Otsu assume histograma bimodal, mas a folha tem **três** populações de pixels:
fundo claro, traço preto do quadradinho e tinta colorida da caneta.

Em teste com caneta azul RGB(63, 72, 204), o valor em tons de cinza é 84,4 e o
Otsu escolheu exatamente 84 como limiar — a marca foi descartada por 0,4 nível.
A folha inteira foi lida como em branco.

O limiar relativo ao fundo resolve o caso e ainda tolera variação de iluminação,
porque o nível de referência é medido na própria imagem.

### Por que o limiar do verde é adaptativo

A dominância do verde varia muito conforme a origem da imagem:

| Origem | Dominância do verde |
|---|---|
| Arquivo digital (PowerPoint) | ~48 |
| Folha impressa e fotografada | ~24 |

Um limiar fixo em 40 funciona no primeiro caso e falha no segundo: sobram poucos
pixels dispersos, o *bounding box* degenera e a grade sai como uma faixa estreita.
O limiar passa a ser metade do verde mais saturado da própria imagem, com piso de 12.

### Por que dois limiares na decisão

São perguntas diferentes:

- **0,40 — "isto é uma alternativa marcada"**: define qual letra foi escolhida
- **0,20 — "aqui existe tinta"**: detecta qualquer intervenção

A verificação de rasura vem **antes** da escolha da letra. Se houver tinta em mais
de uma alternativa, a questão é anulada mesmo que uma delas esteja muito mais
preenchida — não cabe ao corretor adivinhar a intenção de quem rasurou.

O limiar de 0,40 também separa preenchimento de letra escrita à mão: em teste, uma
questão com a letra "D" desenhada dentro do quadradinho mediu 0,26, contra 0,67–0,88
das marcações reais.

## Valores medidos

Folha fotografada, 8 questões:

| Situação | Fração de tinta |
|---|---|
| Quadradinho preenchido | 0,67 – 0,93 |
| Letra escrita à mão | 0,26 – 0,29 |
| Célula vazia | 0,00 – 0,15 |

## Limitações conhecidas

- **Perspectiva e rotação** — a grade é obtida por divisão aritmética do
  *bounding box* da moldura, o que pressupõe a folha alinhada e fotografada de
  frente. Numa foto inclinada a moldura vira um trapézio, mas o código continua
  usando o retângulo que a envolve, e as células saem deslocadas. A correção
  adequada seria detectar os quatro cantos da moldura e aplicar transformação
  projetiva (`fitgeotrans` + `imwarp`) antes de dividir a grade.
- **Margem do limiar de rasura** — células vazias chegam a 0,15 em fotografia,
  contra o limiar de 0,20. A folga é pequena; sombra forte ou papel amassado pode
  gerar anulação indevida. O valor deve ser reconferido a cada lote de imagens.
- **Distribuição das colunas** — na folha de referência, os quadradinhos não estão
  distribuídos uniformemente dentro da moldura (passo real ~97 px contra ~90 px
  calculados). O recorte de 25% absorve o desvio, mas a folga é menor do que o
  ideal.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `corrigirGabarito.m` | leitor principal |
| `folha_azul_1A.png` | folha de referência, caneta azul, questão 1 = A |
| `folha_preta_1D.png` | folha de referência, caneta preta, questão 1 = D |
| `folha_foto.jpg` | folha impressa e fotografada |
| `teste2.png` … `teste5.png` | folhas adicionais de teste |

## Requisitos

MATLAB com Image Processing Toolbox (`imread`, `im2gray`, `bwareaopen`,
`bwareafilt`, `imshow`).