clear all
close all
clc
addpath('./Window_detection');
%Directory where the masks of the different sets are placed
directory_read = '../Results';
directory_write = '../Results';

% directory_mask_train = '../Images/train'; 
% directory_mask_test = '../Images/test'; 

%load the images
 

%Names of the different methods we have used for the segmentation
methods = {'HSV_CCL' 'HSV&RGB_CCL' 'HSV_SW' 'HSV&RGB_SW' 'HSV_II' 'HSV&RGB_II'};
meth = [      1      2       3           4           5               6   ];
%We create the colorSp vector because the switch works better with numbers


window_method = 1;
path_images_read = directory_read;
switch window_method
    case 1
        path_images_read = strcat(path_images_read, '/week_03/train_result/HSV_CCL/');
    case 2
        path_images_read = strcat(path_images_read, '/week_03/train_result/HSV&RGB_CCL/');
    case 3
        path_images_read = strcat(path_images_read, '/week_03/train_result/HSV_SW/');
    case 4
        path_images_read = strcat(path_images_read, '/week_03/train_result/HSV&RGB_SW/');
    case 5
        path_images_read = strcat(path_images_read, '/week_03/train_result/HSV_II/');
    case 6
        path_images_read = strcat(path_images_read, '/week_03/train_result/HSV&RGB_II/');
       

end

direct = dir(strcat(path_images_read,'*.mat'));

Metrica = SignDetectionWindow( window_method, direct, directory_read, directory_write );
