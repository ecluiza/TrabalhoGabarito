clear all;
clc;

imagemOriginalLena = imread('lenaRGB.png');
imgR = imagemOriginalLena(:, :, 1);
imgG = imagemOriginalLena(:, :, 2);
imgB = imagemOriginalLena(:, :, 3);

[M, N] = size(imgR);

msgR_orig = imread('Mensagem1RGB.bmp');
msgG_orig = imread('Mensagem2RGB.bmp');
msgB_orig = imread('Mensagem3RGB.bmp');

imgR_marcado = imgR;
imgG_marcado = imgG;
imgB_marcado = imgB;

for i = 1:M
    for j = 1:N
        imgR_marcado(i, j) = bitset(imgR(i, j), 1, msgR_orig(i, j));
        imgG_marcado(i, j) = bitset(imgG(i, j), 1, msgG_orig(i, j));
        imgB_marcado(i, j) = bitset(imgB(i, j), 1, msgB_orig(i, j));
    end
end

imgJunto = cat(3, imgR_marcado, imgG_marcado, imgB_marcado);
imwrite(imgJunto, 'marcadaRGB3Msgs.bmp');

extR = zeros(M, N);
extG = zeros(M, N);
extB = zeros(M, N);

for i = 1:M
    for j = 1:N
        extR(i, j) = bitget(imgJunto(i, j, 1), 1);
        extG(i, j) = bitget(imgJunto(i, j, 2), 1);
        extB(i, j) = bitget(imgJunto(i, j, 3), 1);
    end
end

imgAdulterada = imgJunto;
imgAdulterada(150:250, 150:250, :) = 0; 
imwrite(imgAdulterada, 'marcadaRGBAdulterada.bmp');

extR_adult = zeros(M, N);
extG_adult = zeros(M, N);
extB_adult = zeros(M, N);

for i = 1:M
    for j = 1:N
        extR_adult(i, j) = bitget(imgAdulterada(i, j, 1), 1);
        extG_adult(i, j) = bitget(imgAdulterada(i, j, 2), 1);
        extB_adult(i, j) = bitget(imgAdulterada(i, j, 3), 1);
    end
end

figure;

subplot(4, 3, 1); imshow(imagemOriginalLena); title('Imagem Original');
subplot(4, 3, 2); imshow(imgJunto); title('Imagem Marcada (RGB)');
subplot(4, 3, 3); imshow(imgAdulterada); title('Imagem Adulterada');

subplot(4, 3, 4); imshow(msgR_orig); title('Msg Original (R)');
subplot(4, 3, 5); imshow(msgG_orig); title('Msg Original (G)');
subplot(4, 3, 6); imshow(msgB_orig); title('Msg Original (B)');

subplot(4, 3, 7); imshow(extR); title('Extraída Canal R');
subplot(4, 3, 8); imshow(extG); title('Extraída Canal G');
subplot(4, 3, 9); imshow(extB); title('Extraída Canal B');

subplot(4, 3, 10); imshow(extR_adult); title('R Pós-Adulteração');
subplot(4, 3, 11); imshow(extG_adult); title('G Pós-Adulteração');
subplot(4, 3, 12); imshow(extB_adult); title('B Pós-Adulteração');