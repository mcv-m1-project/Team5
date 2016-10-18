%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 2 Task 1 and 2  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Our methods
addpath('./Morphologic_operators');
Img = imread('text.png');
figure, imshow(Img)
A = im2bw(Img);
se = mystrel('square', 3);

myimDilated = myDilation(A, se);
figure, imshow(myimDilated)

myimEroded = myErosion(A, se);
figure, imshow(myimEroded)

myimOpened = myOpening(A, se);
figure, imshow(myimOpened)

myimClosed = myClosing(A, se);
figure, imshow(myimClosed)

myimTopHat = myTopHat(A, se);
figure, imshow(myimTopHat)

myimDualTopHat = myDualTopHat(A, se);
figure, imshow(myimDualTopHat)
%%
%Matlab methods
Img = imread('cameraman.tif');
se = strel('line',11,90);

IM2 = imdilate(Img, SE);


IM2 = imerode(IM, SE);

IM2 = imopen(IM,SE);

IM2 = imclose(IM,SE);

IM2 = imtophat(IM,SE);