clear all
close all
clc
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
%%
