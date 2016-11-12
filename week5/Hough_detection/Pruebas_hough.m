clear all
close all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';

%Set to evaluate: train, validate or test
set_type = 'train';
compute_metrics = 0;
%Names of the previous work to compute the correlation
colorSpaces = {'HSV_CCL', 'Gray_image'};
colorSp = [      1         2] ;

[ params, files, SC_train] = compute_paremeters_w5( directory_results, directory_images, set_type, compute_metrics);

params.directory_read_mask = strcat(params.directory_read_mask, '/HSV/');
params.directory_read_window = strcat(params.directory_read_window, '/HSV_CCL/');
params.directory_write_results = strcat(params.directory_write_results, '/HSV_CCL_Hough/');
params.colorSpace = 1;