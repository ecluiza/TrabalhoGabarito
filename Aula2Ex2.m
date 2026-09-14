clear all;
clc;

imgIF = imread("if.jpg");
imgIFG = rgb2gray(imgIF);
imgMenor = imresize(imgIFG, 0.7);

figure(1), imshow(imgIF);
figure(2), imshow(imgIFG);
figure(3), imshow(imgMenor);

figure(4), subplot(1,3,1), imagesc(imgIF), title('Colorida');
figure(4), subplot(1,3,2), imagesc(imgIFG), title('Cinza');
figure(4), subplot(1,3,3), imagesc(imgMenor), title('Menor');

figure(5), subplot(1,3,1), colormap(gray), imagesc(imgIF);
figure(5), subplot(1,3,2), colormap(gray), imagesc(imgIFG);
figure(5), subplot(1,3,3), colormap(gray), imagesc(imgMenor);
