clear all;
clc;

a = imread('Lena512.bmp');
b = imnoise(a, 'gaussian');
c = imnoise(a, 'gaussian',0, 0.003);
d = imnoise(a, 'salt & pepper');
e = imnoise(a, 'salt & pepper', 0.05);

figure(1), subplot(3,3,2), imshow(a), title('Imagem Original');
figure(1), subplot(3,3,4), imshow(b), title('Gaussian');
figure(1), subplot(3,3,6), imshow(c), title('Gaussian 0.003');
figure(1), subplot(3,3,7), imshow(d), title('Salt & Pepper');
figure(1), subplot(3,3,9), imshow(e), title('Salt & Pepper 0.05');
