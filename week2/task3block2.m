%Morfology
% This function applies morfological operators in order to reduce noise 
% of the generated masks. 
clear all
close all
 archivos = dir('*.jpg'); %load the images

    for k = 1:length(archivos)
        
%The masks are loaded
 mask=imread(archivos(k).name);
 imagename = archivos(k).name(1:end-4);
 
%  imshow(mask);
 
 %First, Structural elements are created
 
 se = strel('diamond',5);
 se2 = strel('line',10,0);
 se3 = strel('line',10,90);
% se4 = strel('square',3);
 

 %Now, holes are filled so we get the hole sign
maskWholes = imfill(mask);
%figure
% imshow(maskWholes);
 % Afterwards, Noise is intended to be removed. Opening operation is used
% since small noise appears on the image.

maskOp = imopen(maskWholes,se);
% figure
% imshow(maskOp);


%At this point, It is tried to removed every vertical line which is not likely
%to be a sign. the goal is to get rid of the stick whick holds the sign

maskOpL = imopen (maskOp, se2);
% figure
% imshow(maskOpL);


maskOpL = imopen (maskOpL, se3);
% figure
% imshow(maskOpL);

        imwrite(maskOpL,strcat('Results/',imagename,'_morf.jpg'));
    end
