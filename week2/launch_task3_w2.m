clear all
close all

%Directory where the masks of the different sets are placed
directory_read = '../Results/week_01';
directory_mask_train = '../Images/train'; 
directory_write = '../Results/week_02';
directory_mask_test = '../Images/test'; 
%load the images
load(strcat(directory_read, '/names_files_train'), 'files_train'); 
load(strcat(directory_read, '/names_files_validate'), 'files_validate'); 

%Names of the different methods we have used for the segmentation
colorSpaces = {'RGBManual' 'HSV' 'YUV' 'HSV&RGB'};
colorSp = [         1        2     3       4     ];
%We create the colorSp vector because the switch works better with numbers

%%
%Evaluate all methods ans save its metrices for train set
directory_read_train = strcat(directory_read, '/train_result');

directory_write_train = strcat(directory_write, '/train_result');

metrix_methods_train = zeros(10, 4);
for i = 1:4
    pixel_method = colorSp(i);
    metr_method = SignDetection_t3w2( pixel_method, files_train, directory_read_train, directory_write_train, directory_mask_train );
    metrix_methods_train(:, i) = metr_method;
end
metrix_methods_train(:, i) = metr_method;
save(strcat(directory_write, '/metrix_methods_train'), 'metrix_methods_train');

%%
%Evaluate all methods ans save its metrices for validate set
directory_read_validate = strcat(directory_read, '/validate_result');
directory_write_validate = strcat(directory_write, '/validate_result');
metrix_methods_validate = zeros(10, 4);
for i = 1:4
    pixel_method = colorSp(i);
    metr_method = SignDetection_t3w2( pixel_method, files_validate, directory_read_validate, directory_write_validate, directory_mask_train );
    metrix_methods_validate(:, i) = metr_method;
end
metrix_methods_validate(:, i) = metr_method;
save(strcat(directory_write_validate, '/metrix_methods_validate'), 'metrix_methods_validate');

%%
% Evaluate all methods for the test set
directory_read_test = strcat(directory_read, '/test_result');
directory_write_test = strcat(directory_write, '/test_result');
directory = directory_read_test;
path_images_write = directory_write_test;
files_test = ListFiles(directory_mask_test);
for i = 1:size(files_test)
    files_test(i).name = files_test(i).name(1:length(files_test(i).name)-4);
end   
Masks = files_test;
for i = 1:4
    pixel_method = colorSp(i);
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
    end
    if ~exist(path_images_write, 'dir')
        mkdir(path_images_write);
    end
    average_time = task3block2(path_masks, Masks, path_images_write);
end