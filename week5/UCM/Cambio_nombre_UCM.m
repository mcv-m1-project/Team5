clear all
close all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';

%Set to evaluate: train, validate or test
set_type = 'validate';

compute_metrics = 1;

%Names of the previous work to compute the correlation
%colorSpaces = {'UCM', 'MS'};
%colorSp = [      1         2] ;


[ params, files, SC_train] = compute_paremeters_w5( directory_results, directory_images, set_type, compute_metrics);

params.directory_write_results = strcat(params.directory_write_results, '/UCM2/');
num_files = size(files, 1);


for i = 1:num_files
    
    image_name = files(i).name;
    
    load(strcat(params.directory_write_results, image_name, '_mask.mat'));
    windowCandidates = finalWindowCandidates;
    save(strcat(params.directory_write_results,'/', files(i).name, '_mask.mat'), 'windowCandidates');
    
end