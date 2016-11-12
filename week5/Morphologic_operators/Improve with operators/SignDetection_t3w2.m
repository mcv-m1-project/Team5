function [ metrix_method ] = SignDetection_t3w2(params, files )
% Add folders of functions to path
addpath('./evaluation')
%  pixel_method, files_train, directory, path_images_write, directory_mask_train

num_files = size(files, 1);
Masks = files;

pixel_method = params.colorSpace;

switch pixel_method
    case 1
        path_images_write = strcat(params.directory_write_results, '/RGBManual/');
        path_masks = strcat(params.directory_read_results, '/RGBManual/');
    case 2
        path_images_write = strcat(params.directory_write_results, '/HSV/');
        path_masks = strcat(params.directory_read_results, '/HSV/');
    case 3
        path_images_write = strcat(params.directory_write_results, '/YUV/');
        path_masks = strcat(params.directory_read_results, '/YUV/');
    case 4
        path_images_write = strcat(params.directory_write_results, '/HSV&RGB/');
        path_masks = strcat(params.directory_read_results, '/HSV&RGB/');
    case 5
        path_images_write = strcat(params.directory_write_results, '/histBP/');
        path_masks = strcat(params.directory_read_results, '/histBP/');
end
if ~exist(path_images_write, 'dir')
    mkdir(path_images_write);
end

%Generate the masks for the given method

average_time = task3block2(path_masks, Masks, path_images_write);

if ~strcmp(params.type_set, 'test')
    TP_images = zeros(num_files, 1);
    FP_images = zeros(num_files, 1);
    FN_images = zeros(num_files, 1);
    TN_images = zeros(num_files, 1);
    
    Precision_images = zeros(num_files, 1);
    Accuracy_images = zeros(num_files, 1);
    Specificit_images = zeros(num_files, 1);
    Sensitivity_images = zeros(num_files, 1);
    FMeasure_images = zeros(num_files, 1);
    for i = 1:num_files
        pixelAnnotation = imread(strcat(params.directory_read_images, '/mask/mask.', char(Masks(i).name), '.png'));
        
        pixelCandidates = imread(strcat(path_images_write, char(Masks(i).name), '_mask.png'));
        
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
else
    metrix_method = [];
    
end
end