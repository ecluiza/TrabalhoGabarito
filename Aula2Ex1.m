clear all;
clc;

imgIF = imread("if.jpg");

imgIFG = rgb2gray(imgIF);

figure(1),imshow(imgIF), title('Imagem Colorida');
figure(2),imshow(imgIFG), title('Imagem Cinza');