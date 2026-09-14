clear all;
clc;

% Quantidade de moedas contada A OLHO em cada foto (ajuste aqui)
moedas_olho1 = 4;
moedas_olho2 = 6;
moedas_olho3 = 8;
moedas_olho4 = 9;
moedas_olho5 = 7;
moedas_olho6 = 13;

m1 = imread("moeda1.bmp");
gray1 = im2gray(m1);
bw1 = gray1 >= 50;              % pixel >= 50 de brilho -> branco (moeda), senão preto
pixels_brancos1 = sum(bw1(:));

m2 = imread("moeda2.bmp");
gray2 = im2gray(m2);
bw2 = gray2 >= 50;
pixels_brancos2 = sum(bw2(:));

m3 = imread("moeda3.bmp");
gray3 = im2gray(m3);
bw3 = gray3 >= 50;
pixels_brancos3 = sum(bw3(:));

m4 = imread("moeda4.bmp");
gray4 = im2gray(m4);
bw4 = gray4 >= 50;
pixels_brancos4 = sum(bw4(:));

m5 = imread("moeda5.bmp");
gray5 = im2gray(m5);
bw5 = gray5 >= 50;
pixels_brancos5 = sum(bw5(:));

m6 = imread("moeda6.bmp");
gray6 = im2gray(m6);
bw6 = gray6 >= 50;
pixels_brancos6 = sum(bw6(:));

% Média geral: soma todos os pixels brancos e divide pela soma de todas as moedas
total_pixels_brancos = pixels_brancos1 + pixels_brancos2 + pixels_brancos3 + ...
    pixels_brancos4 + pixels_brancos5 + pixels_brancos6;
total_moedas_olho = moedas_olho1 + moedas_olho2 + moedas_olho3 + ...
    moedas_olho4 + moedas_olho5 + moedas_olho6;
media_por_moeda = total_pixels_brancos / total_moedas_olho;

% Agora aplica a média geral em cada foto
num_moedas1 = round(pixels_brancos1 / media_por_moeda);
num_moedas2 = round(pixels_brancos2 / media_por_moeda);
num_moedas3 = round(pixels_brancos3 / media_por_moeda);
num_moedas4 = round(pixels_brancos4 / media_por_moeda);
num_moedas5 = round(pixels_brancos5 / media_por_moeda);
num_moedas6 = round(pixels_brancos6 / media_por_moeda);

subplot(2,3,1), imshow(m1); title(sprintf('%d moedas', num_moedas1));
subplot(2,3,2), imshow(m2); title(sprintf('%d moedas', num_moedas2));
subplot(2,3,3), imshow(m3); title(sprintf('%d moedas', num_moedas3));
subplot(2,3,4), imshow(m4); title(sprintf('%d moedas', num_moedas4));
subplot(2,3,5), imshow(m5); title(sprintf('%d moedas', num_moedas5));
subplot(2,3,6), imshow(m6); title(sprintf('%d moedas', num_moedas6));