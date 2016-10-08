%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 1 Task 4  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
%Add folders of functions to path
addpath('./evaluation')
addpath('./colorspace')
addpath('./circular_hough')

Folder_gt = './train/mask';
Files = ListFiles(Folder_gt);
files = size(Files, 1);
TP_images = zeros(files, 1);
FP_images = zeros(files, 1);
FN_images = zeros(files, 1);
TN_images = zeros(files, 1);

for i = 1:files
    mask = imread(strcat('./train/mask', Files(i)));
    pixelAnnotation = mask > 128;
    %Compute pixelCandidates!!!!!
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
    TP_images(i) = pixelTP;
    FP_images(i) = pixelFP;
    FN_images(i) = pixelFN;
    TN_images(i) = pixelTN;
end  

average_TP = mean(TP_images);
average_FP = mean(FP_images);
average_FN = mean(FN_images);
average_TN = mean(TN_images);