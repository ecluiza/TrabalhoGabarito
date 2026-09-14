clear all;
clc;

a = imread('Lena512.bmp');
b = imcomplement(a);

figure(1), subplot(1,2,1), imshow(a), title('Imagem Original');
figure(1), subplot(1,2,2), imshow(b), title('Imagem Negativo');

imwrite (b, 'lenaNegativo.bmp');