%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 2 Task 1 and 2  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Comparison
addpath('./Morphologic_operators');
Img = imread('cameraman.tif');
figure, imshow(Img)
Img = im2bw(Img);
myse = mystrel('square', 3);
se = strel('square', 3);

%%
myimDilated = myDilation(Img, myse);
figure, imshow(myimDilated)
imDilated = imdilate(Img, se);
figure, imshow(imDilated)
diff_dilate = double(imDilated) - myimDilated;
figure, imshow(uint8(diff_dilate));

%%
myimEroded = myErosion(Img, myse);
figure, imshow(myimEroded)
imEroded = imerode(Img, se);
figure, imshow(imEroded)
diff_erosion = double(imEroded) - myimEroded;
figure, imshow(uint8(diff_erosion));

%%
myimOpened = myOpening(Img, myse);
figure, imshow(myimOpened)
imOpened = imopen(Img,se);
figure, imshow(imOpened)
diff_open = double(imOpened) - myimOpened;
figure, imshow(uint8(diff_open));

%%
myimClosed = myClosing(Img, myse);
figure, imshow(myimClosed)
imClosed = imclose(Img,se);
figure, imshow(imClosed)
diff_close = double(imClosed) - myimClosed;
figure, imshow(uint8(diff_close));

%%
myimTopHat = myTopHat(Img, myse);
figure, imshow(myimTopHat)
imTopHat = imtophat(Img,se);
figure, imshow(imTopHat)
diff_tophat = double(imTopHat) - myimTopHat;
figure, imshow(uint8(diff_tophat));

%%
myimDualTopHat = myDualTopHat(Img, myse);
figure, imshow(myimDualTopHat)
imDualTopHat = imbothat(Img,se);
figure, imshow(imDualTopHat)
diff_dualtophat = double(imDualTopHat) - myimDualTopHat;
figure, imshow(uint8(diff_dualtophat));

%%
%Timing
% Columns:
% 1 Time our method
% 2 Time matlab method
% 3 Efficiency (100*#1/#2)

Times = zeros(6, 3);

addpath('./Morphologic_operators');
Img = imread('cameraman.tif');
figure, imshow(Img)
Img = im2bw(Img);

myse = mystrel('square', 3);
se = strel('square', 3);


% Dilation
tic
for i = 1:1000
    myimDilated = myDilation(Img, myse);
end
Times(1, 1) = toc/1000;

tic
for i = 1:1000
    imDilated = imdilate(Img, se);
end
Times(1, 2) = toc/1000;
Times(1, 3) = 100*Times(1, 1)/Times(1, 2);

% Erosion
tic
for i = 1:1000
    myimEroded = myErosion(Img, myse);
end
Times(2, 1) = toc/1000;

tic
for i = 1:1000
    imEroded = imerode(Img, se);
end
Times(2, 2) = toc/1000;
Times(2, 3) = 100*Times(2, 1)/Times(2, 2);

% Opening
tic
for i = 1:1000
    myimOpened = myOpening(Img, myse);
end
Times(3, 1) = toc/1000;

tic
for i = 1:1000
    imOpened = imopen(Img,se);
end
Times(3, 2) = toc/1000;
Times(3, 3) = 100*Times(3, 1)/Times(3, 2);

% Closing
tic
for i = 1:1000
    myimClosed = myClosing(Img, myse);
end
Times(4, 1) = toc/1000;

tic
for i = 1:1000
    imClosed = imclose(Img,se);
end
Times(4, 2) = toc/1000;
Times(4, 3) = 100*Times(4, 1)/Times(4, 2);


% Top Hat
tic
for i = 1:1000
    myimTopHat = myTopHat(Img, myse);
end
Times(5, 1) = toc/1000;

tic
for i = 1:1000
    imTopHat = imtophat(Img,se);
end
Times(5, 2) = toc/1000;
Times(5, 3) = 100*Times(5, 1)/Times(5, 2);


% Dual Top Hat
tic
for i = 1:1000
    myimDualTopHat = myDualTopHat(Img, myse);
end
Times(6, 1) = toc/1000;

tic
for i = 1:1000
    imDualTopHat = imbothat(Img,se);
end
Times(6, 2) = toc/1000;
Times(6, 3) = 100*Times(6, 1)/Times(6, 2);

directory_write = '../Results';
save(strcat(directory_write, '/Times_operators'), 'Times');


