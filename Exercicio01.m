clear all;
clc;

a = imread ('lena128.bmp');
b = imread ('cameraman128.bmp');
c = uint8(zeros(256,128));
 
for i = 1:256;
    for j = 1:128;
        if i<129
            c(i,j) = a(i,j);
        else
            c(i,j) = b(i-128,j);
        end
    end
end

figure(1), imshow(c);
imwrite(c, 'Exercicio01.bmp');