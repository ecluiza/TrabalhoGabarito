clear all;
clc;

img = imread ('moeda.png');
img = rgb2gray(img);

imgRuido = imnoise(img, 'salt & pepper', 0.01);
imgSuavizada = medfilt2(imgRuido);

figure(1), subplot(1,3,1), imshow(img);
figure(1), subplot(1,3,2), imshow(imgRuido);
figure(1), subplot(1,3,3), imshow(imgSuavizada);

imwrite (imgRuido, 'imgRuido.png');