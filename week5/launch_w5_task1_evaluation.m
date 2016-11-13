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


%%



metrix_pixel = SignDetectionUCM_pixel_ev(params, files);
metrix_region = SignDetectionUCM_region_ev(params, files);

if ~isempty(metrix_pixel)
    save(strcat(params.directory_write_results, '/metrix_pixel_', params.type_set, '_task01'), 'metrix_pixel');
    save(strcat(params.directory_write_results, '/metrix_regions_', params.type_set, '_task01'), 'metrix_region');
end
sprintf(params.type_set)