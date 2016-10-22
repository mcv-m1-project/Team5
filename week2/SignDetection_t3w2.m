function [ metrix_method ] = SignDetection_t3w2( pixel_method, files_train, directory, path_images_write, directory_mask_train )
% Add folders of functions to path
addpath('./evaluation')


files = size(files_train, 1);
Masks = files_train;

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
        path_images_write = strcat(path_images_write, '/RGBManual/');
        path_masks = strcat(directory, '/RGBManual/');
    case 2
        path_images_write = strcat(path_images_write, '/HSV/');
        path_masks = strcat(directory, '/HSV/');
    case 3
        path_images_write = strcat(path_images_write, '/YUV/');
        path_masks = strcat(directory, '/YUV/');
    case 4
        path_images_write = strcat(path_images_write, '/HSV&RGB/');
        path_masks = strcat(directory, '/HSV&RGB/');
    case 5
        path_images_write = strcat(path_images_write, '/histBP/');
        path_masks = strcat(directory, '/histBP/');
end        
if ~exist(path_images_write, 'dir')
    mkdir(path_images_write);
end

%Generate the masks for the given method
% average_time = Task3block1(path_images, List_of_images, path_images_write, pixel_method);
average_time = task3block2(path_masks, Masks, path_images_write);
for i = 1:files
    pixelAnnotation = imread(strcat(directory_mask_train, '/mask/mask.', char(Masks(i).name), '.png'));

    pixelCandidates = imread(strcat(path_images_write, char(Masks(i).name), '_morf.jpg'));
    
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


% The vector metrix_method contains the measures of the method
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