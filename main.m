Img = imread('text.png');
figure,imshow(Img)
A=im2bw(Img);
se = mystrel('square',3);
imDilated=myDilation(A, se);
figure,imshow(imDilated)
imEroded=myErosion(A, se);
figure,imshow(imEroded)