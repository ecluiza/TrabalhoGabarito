clear all;
clc;

imgESC = imread('Escuro.bmp');

figure(1),imshow(imgESC), title('Imagem Escura');

imgEq = histeq(imgESC);

figure(1), imshow(imgESC), title('Imagem Original');
figure(2), imshow(imgEq), title('Imagem Equalizada');
figure(3), imhist(imgESC), title('Histograma da Imagem Original');
figure(4), imhist(imgEq), title('Histograma da Imagem Equalizada');

imwrite(imgEq, 'imagemEqualizadaAula.bmp');