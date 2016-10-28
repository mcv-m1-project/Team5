function [ metrix_method ] = SignDetectionWindow( window_method, files_train, directory, path_images_write )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 3 Task 4  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Add folders of functions to path
addpath('./evaluation')


% Folder_mask = './train/mask';
% Files = ListFiles(Folder_mask);


% List_of_images =  ListFiles('./train/');
% files = size(List_of_images, 1);

files = size(files_train, 1);
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
  
%revise
switch window_method
    case 1
        path = strcat(path_images_write, '/BBox/Slicing/');
    case 2
        path = strcat(path_images_write, '/Masks/Integral/');
end        

path_images = directory;
%Generate the masks for the given method
average_time = Task3block1(path_images, List_of_images, path_images_write, window_method);

for i = 1:files
    %revise
    windowAnnotation = List_of_images(i);

    windowCandidates = List_of_images(i);
    
    [windowTP, windowFP, windowFN, windowTN] = PerformanceAccumulationwindow(windowCandidates, windowAnnotation);
    [windowPrecision, windowAccuracy, windowSpecificity, windowSensitivity, windowFMeasure] = PerformanceEvaluationwindow(windowTP, windowFP, windowFN, windowTN);
    TP_images(i) = windowTP;
    FP_images(i) = windowFP;
    FN_images(i) = windowFN;
    TN_images(i) = windowTN;
    Precision_images(i) = windowPrecision;
    Accuracy_images(i) = windowAccuracy;
    Specificit_images(i) = windowSpecificity;
    Sensitivity_images(i) = windowSensitivity;
    FMeasure_images(i) = windowFMeasure;
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
