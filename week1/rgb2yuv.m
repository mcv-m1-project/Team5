%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function rgb2yuv converts the RB matrix of an image to an YUV format%
%matrix for the image. It plots the images, if Plot Flag is eqaul to 1.   %
%                                                                         %
%Example                                                                  %
%file=('C:\Image0474.jpg');                                               %
%plotflag=1;                                                              %
%RGB = imread(file);                                                      %
%imshow(RGB);                                                             %
%YUV=rgb2yuv(RGB);                                                        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function YUV=rgb2yuv(RGB)

R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);

%Conversion Formula
Y = 0.299   * R + 0.587   * G + 0.114 * B;
U =128 - 0.168736 * R - 0.331264 * G + 0.5 * B;
V =128 + 0.5 * R - 0.418688 * G - 0.081312 * B;
YUV=cat(3,Y,U,V);

end