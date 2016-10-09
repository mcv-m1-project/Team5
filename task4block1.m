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
Precision_images = zeros(files, 1);
Accuracy_images = zeros(files, 1);
Specificit_images = zeros(files, 1);
Sensitivity_images = zeros(files, 1);

for i = 1:files
    mask = imread(strcat('./train/mask', Files(i)));
    pixelAnnotation = mask > 128;
    %Compute pixelCandidates!!!!!
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
    TP_images(i) = pixelTP;
    FP_images(i) = pixelFP;
    FN_images(i) = pixelFN;
    TN_images(i) = pixelTN;
    Precision_images(i) = pixelPrecision;
    Accuracy_images(i) = pixelAccuracy;
    Specificit_images(i) = pixelSpecificity;
    Sensitivity_images(i) = pixelSensitivity;
end

average_TP = mean(TP_images);
average_FP = mean(FP_images);
average_FN = mean(FN_images);
average_TN = mean(TN_images);