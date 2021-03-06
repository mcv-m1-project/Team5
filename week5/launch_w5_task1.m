clear all
close all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';

%Set to evaluate: train, validate or test
set_type = 'test';

compute_metrics = 1;

%Names of the previous work to compute the correlation
%colorSpaces = {'UCM', 'MS'};
%colorSp = [      1         2] ;


[ params, files, SC_train] = compute_paremeters_w5( directory_results, directory_images, set_type, compute_metrics);


%%

metrix_methods = zeros(7, 1);
%for i = 1:length(colorSp)
    %params.colorSpace = colorSp(i);
    metrix = SignDetectionUCM(params, files, SC_train);
    if ~isempty(metrix)
        metrix_methods(:, 1) = metrix;
    end
%end
if ~isempty(metrix)
    save(strcat(params.directory_write_results, '/metrix_methods_', params.type_set, '_task01'), 'metrix_methods');
end
sprintf(params.type_set)