clear all;
clc;
img = imread('imgRuido.png');
[M,N] = size(img);

c = img;
c = double (c);
for i=2:M-1
    for j=2:N-1
        c(i,j) = [((1*(c(i-1,j-1))) + (1*(c(i-1,j))) + (1*(c(i-1,j+1))) ...
                 +(1*(c(i,j-1))) + (1*(c(i,j))) + (1*(c(i,j+1))) ...
                 +(1*(c(i+1,j-1))) + (1*(c(i+1,j))) + (1*(c(i+1,j+1))))/9];
    end
end

c = uint8(c);
figure(1), subplot(1,2,1), imshow(img);
figure(1), subplot(1,2,2), imshow(c);
imwrite (c, 'ifmedia.bmp');