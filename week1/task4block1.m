%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 1 Task 4  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
%Add folders of functions to path
addpath('./evaluation')
addpath('./colorspace')
addpath('./circular_hough')

Folder_mask = './train/mask';
Files = ListFiles(Folder_mask);
files = size(Files, 1);

List_of_images =  ListFiles('./train/');

TP_images = zeros(files, 1);
FP_images = zeros(files, 1);
FN_images = zeros(files, 1);
TN_images = zeros(files, 1);

Precision_images = zeros(files, 1);
Accuracy_images = zeros(files, 1);
Specificit_images = zeros(files, 1);
Sensitivity_images = zeros(files, 1);
FMeasure_images = zeros(files, 1);
% for i = 1:4
%     Mask4('./train/', i)
% end    


%%
colorSpace = 5;
switch colorSpace
    case 1
        path = './train/Masks/OtsuRGB/';
    case 2
        path = './train/Masks/HSV/';
    case 3
        path = './train/Masks/Lab/';
    case 4
        path = './train/Masks/HSV&RGB/';
    case 5
        path = './train/Masks/RGBManual/';
    case 6
        path = './train/Masks/YUV/';
end        
    
for i = 1:files
    pixelAnnotation = imread(strcat('./train/mask/', char(Files(i).name)));

    pixelCandidates = imread(strcat(path, char(List_of_images(i).name(1:length(List_of_images(i).name)-4)), '_mask.jpg'));
    
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
    [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelFMeasure] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
    TP_images(i) = pixelTP;
    FP_images(i) = pixelFP;
    FN_images(i) = pixelFN;
    TN_images(i) = pixelTN;
    Precision_images(i) = pixelPrecision;
    Accuracy_images(i) = pixelAccuracy;
    Specificit_images(i) = pixelSpecificity;
    Sensitivity_images(i) = pixelSensitivity;
    FMeasure_images(i) = pixelFMeasure;
end

average_TP = mean(TP_images);
average_FP = mean(FP_images);
average_FN = mean(FN_images);
average_TN = mean(TN_images);

Precision_images(isnan(Precision_images))=0;
average_Precision = mean(Precision_images);
average_Accuracy = mean(Accuracy_images);
average_Specificit = mean(Specificit_images);
average_sensitivity = mean(Sensitivity_images);
average_FMeasure = mean(FMeasure_images);
