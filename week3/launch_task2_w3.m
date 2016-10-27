clear all
close all
clc
addpath('./Window_detection');
%Directory where the masks of the different sets are placed
directory_read = '../Results';
directory_write = '../Results/week_03';

% directory_mask_train = '../Images/train'; 
% directory_mask_test = '../Images/test'; 
%load the images
load(strcat(directory_read, '/week_01/Sign_characteristics_train')); 

load(strcat(directory_read, '/week_01/names_files_validate'), 'files_validate'); 

%Names of the different methods we have used for the segmentation
colorSpaces = {'RGBManual' 'HSV' 'YUV' 'HSV&RGB' 'histBP'};
colorSp = [         1        2     3       4         5];
%We create the colorSp vector because the switch works better with numbers


pixel_method = 4;
path_images_read = directory_read;
switch pixel_method
    case 1
        path_images_read = strcat(path_images_read, '/week_02/train_result/RGBManual/');
    case 2
        path_images_read = strcat(path_images_read, '/week_02/train_result/HSV/');
    case 3
        path_images_read = strcat(path_images_read, '/week_02/train_result/YUV/');
    case 4
        path_images_read = strcat(path_images_read, '/week_02/train_result/HSV&RGB/');
    case 5
        path_images_read = strcat(path_images_read, '/week_02/train_result/histBP/');
end
