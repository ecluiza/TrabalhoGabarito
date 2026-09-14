clear all;
clc;

m1 = imread ("moeda1.bmp");
bw = imbinarize (im2gray(m1));
[~, num_moedas] = bwlabel(bw);

m2 = imread ("moeda2.bmp");
bw2 = imbinarize (im2gray(m2));
[~, num_moedas2] = bwlabel(bw2);

m3 = imread ("moeda3.bmp");
bw3 = imbinarize (im2gray(m3));
[~, num_moedas3] = bwlabel(bw3);

m4 = imread ("moeda4.bmp");
bw4 = imopen(imbinarize (im2gray(m4)), strel('disk',4));
[~, num_moedas4] = bwlabel(bw4);

m5 = imread ("moeda5.bmp");
bw5 = imopen(imbinarize (im2gray(m5)), strel('disk',4));
[~, num_moedas5] = bwlabel(bw5);

m6 = imread ("moeda6.bmp");
bw6 = imopen(imbinarize (im2gray(m6)), strel('disk',4));
[~, num_moedas6] = bwlabel(bw6);

subplot(2,3,1), imshow(m1); title(sprintf('%d moedas', num_moedas));
subplot(2,3,2), imshow(m2); title(sprintf('%d moedas', num_moedas2));
subplot(2,3,3), imshow(m3); title(sprintf('%d moedas', num_moedas3));
subplot(2,3,4), imshow(m4); title(sprintf('%d moedas', num_moedas4));
subplot(2,3,5), imshow(m5); title(sprintf('%d moedas', num_moedas5));
subplot(2,3,6), imshow(m6); title(sprintf('%d moedas', num_moedas6));