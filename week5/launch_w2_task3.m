clear all
close all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';

%Set to evaluate: train, validate or test
set_type = 'test';


%Names of the different methods we have used for the segmentation
colorSpaces = {'RGBManual' 'HSV' 'YUV' 'HSV&RGB' 'histBP'};
colorSp = [         1        2     3       4         5];

%We create the colorSp vector because the switch works better with numbers

[ params, files] = compute_paremeters_w2( directory_results, directory_images, set_type );


%%
%Evaluate all methods ans save its metrices 
metrix_methods = zeros(10, length(colorSp));

for i = 1:length(colorSp)
    sprintf(char(colorSpaces(colorSp(i))))
    params.colorSpace = colorSp(i);
    metr_method = SignDetection_t3w2(params, files);

    if ~isempty(metr_method)
        metrix_methods(:, i) = metr_method;
    end
end

if ~strcmp(params.type_set, 'test')
    save(strcat(params.directory_write_results, '/metrix_methods_morph_operators'), 'metrix_methods');
end 


