clear all
close all
clc
addpath(genpath('.'))

template = Template(4, [80 80]);
% template = rgb2gray(imread('../Results_fins_week3/Triangles/tr01.png'))/255;
% template = imrotate(template, 90);
BW = edge(template, 'canny');
template = padarray(template, [4 4]);
[H,T,R] = hough(BW);


subplot(2,1,1);
imshow(template);

subplot(2,1,2);
imshow(imadjust(mat2gray(H)),'XData', T,'YData',R,...
      'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
% colormap(gca,hot);