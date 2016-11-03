%Task 1 w4
clear all; close all;

siz=[20,20];

circle = template_model1(siz);
figure();
imshow(circle);

square = template_model2(siz);
figure();
imshow(square);

triangle = template_model3(siz);
figure();
imshow(triangle);

itriangle = template_model4(siz);
figure();
imshow(itriangle);

