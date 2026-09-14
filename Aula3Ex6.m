clear all;
clc;

[filename, pathname] = uigetfile({'*.bmp'}, 'Seleicone a Imagem');
[img] = imread(filename);
img = rgb2gray(img);

imgSobel = edge(img, 'sobel');
imgCanny = edge(img, 'canny', 0.1);
imgRoberts = edge(img, 'roberts');
imgPrewitt = edge(img, 'prewitt');

imwrite(imgSobel, 'ImagemSobel.bmp');
imwrite(imgCanny, 'ImagemCanny.bmp');
imwrite(imgRoberts, 'ImagemRoberts.bmp');
imwrite(imgPrewitt, 'ImagemPrewitt.bmp');

figure(1), subplot(3,3,2), imshow(img), title('Imagem original');
figure(1), subplot(3,3,1), imshow(imgSobel), title('Imagem Filtro Sobel');
figure(1), subplot(3,3,3), imshow(imgCanny), title('Imagem Filtro Canny');
figure(1), subplot(3,3,4), imshow(imgRoberts), title('Imagem Filtro Roberts');
figure(1), subplot(3,3,5), imshow(imgPrewitt), title('Imagem Filtro Prewitt');
