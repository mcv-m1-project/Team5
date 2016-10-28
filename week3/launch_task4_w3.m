clear all
close all
clc
addpath('./Window_detection');
%Directory where the masks of the different sets are placed
directory_read = '../Results/week_03';
directory_write = '../Results/';

% directory_mask_train = '../Images/train'; 
% directory_mask_test = '../Images/test'; 

%load the images
load(strcat(directory_read, 'BBox.mat')); 

%Names of the different methods we have used for the segmentation
colorSpaces = {'slicinWindow' 'Integral'};
colorSp = [         1               2          ];
%We create the colorSp vector because the switch works better with numbers


pixel_method = 1;
path_images_read = directory_read;
switch pixel_method
    case 1
        path_images_read = strcat(path_images_read, '/week_03/train_result/Slicing/');
    case 2
        path_images_read = strcat(path_images_read, '/week_03/train_result/Integral/');

end
