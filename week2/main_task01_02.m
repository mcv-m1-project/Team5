%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 2 Task 1 and 2  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('./Morphologic_operators');
Img = imread('text.png');
figure,imshow(Img)
A = im2bw(Img);
se = mystrel('square',3);

imDilated=myDilation(A, se);
figure,imshow(imDilated)

imEroded=myErosion(A, se);
figure,imshow(imEroded)

imOpened=myOpening(A, se);
figure,imshow(imOpened)

imClosed = myClosing(A, se);
figure,imshow(imClosed)

imTopHat=myTopHat(A, se);
figure,imshow(imTopHat)

imDualTopHat = myDualTopHat(A, se);
figure,imshow(imDualTopHat)
