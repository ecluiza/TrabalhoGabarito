clear all;
clc;

a = imread ('lena128.bmp');
b = imread ('cameraman128.bmp');
c = uint8(zeros(128,256));
 
for i = 1:128;
    for j = 1:256;
        if j<129
            c(i,j) = a(i,j);
        else
            c(i,j) = b(i,j-128);
        end
    end
end

figure(1), imshow(c);
imwrite(c, 'lenacameraman.bmp');