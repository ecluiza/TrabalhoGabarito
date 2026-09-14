clear all;
clc;

imgRGB = imread('fotoIF.jpg');
imgR = imgRGB(:,:,1);
imgG = imgRGB(:,:,2);
imgB = imgRGB(:,:,3);

a = imadd(imgR, 100);
b = imadd(imgG, 100);
c = imadd(imgB, 100);

imgRGB1 = cat(3, a, b, c);

imgRGB_R = cat(3, a, imgG, imgB);
imgRGB_G = cat(3, imgR, b, imgB);
imgRGB_B = cat(3, imgR, imgG, c);

figure(1), subplot(3,4,1), imshow(imgRGB), title('Imagem Original');
figure(1), subplot(3,4,2), imshow(imgR), title('Imagem R');
figure(1), subplot(3,4,3), imshow(imgG), title('Imagem G');
figure(1), subplot(3,4,4), imshow(imgB), title('Imagem B');
figure(1), subplot(3,4,5), imshow(a), title('Imagem R Clara');
figure(1), subplot(3,4,6), imshow(b), title('Imagem G Clara');
figure(1), subplot(3,4,7), imshow(c), title('Imagem B Clara');
figure(1), subplot(3,4,8), imshow(imgRGB1), title('Imagem RGB Nova');
figure(1), subplot(3,4,8), imshow(imgRGB1), title('Imagem RGB Nova');
figure(1), subplot(3,4,9), imshow(imgRGB_R), title('Imagem RGB R Alterado');
figure(1), subplot(3,4,10), imshow(imgRGB_G), title('Imagem RGB G Alterado');
figure(1), subplot(3,4,11), imshow(imgRGB_B), title('Imagem RGB B Alterado');


