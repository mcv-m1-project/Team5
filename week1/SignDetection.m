function [ metrix_method ] = SignDetection( pixel_method, files_train )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 1 Task 4  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Add folders of functions to path
addpath('./evaluation')
addpath('./colorspace')
addpath('./circular_hough')

% Folder_mask = './train/mask';
% Files = ListFiles(Folder_mask);
files = size(files_trains, 1);

List_of_images =  files_train;

TP_images = zeros(files, 1);
FP_images = zeros(files, 1);
FN_images = zeros(files, 1);
TN_images = zeros(files, 1);

Precision_images = zeros(files, 1);
Accuracy_images = zeros(files, 1);
Specificit_images = zeros(files, 1);
Sensitivity_images = zeros(files, 1);
FMeasure_images = zeros(files, 1);
  

switch pixel_method
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
end        
path_images = './train/';
%Generate the masks for the given method
average_time = Mask4(path_images, files_train, pixel_method);

for i = 1:files
    pixelAnnotation = imread(strcat('./train/mask/', char(List_of_images(i).name(1:length(List_of_images(i).name)-4)), '.jpg'));

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

% Precision_images(isnan(Precision_images))=0;
average_Precision = mean(Precision_images);
average_Accuracy = mean(Accuracy_images);
average_Specificit = mean(Specificit_images);
average_sensitivity = mean(Sensitivity_images);
average_FMeasure = mean(FMeasure_images);


%The vector metrix_method contains the measures of the method
% 1 average_Precision
% 2 average_Accuracy
% 3 average_sensitivity 
% 4 average_FMeasure 
% 5 average_Specificit
% 6 average_TP
% 7 average_FP
% 8 average_FN
% 9 average_TN
% 10 average_time

metrix_method = [average_Precision; average_Accuracy; average_sensitivity; average_FMeasure; average_Specificit];
metrix_method = [metrix_method; average_TP; average_FP; average_FN; average_TN; average_time];
end

