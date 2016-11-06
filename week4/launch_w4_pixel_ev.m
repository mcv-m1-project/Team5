clear all
close all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';
directory_templates = '../Results/week_04/Templates';

%Set to evaluate: train, validate or test
set_type = 'validate';

%Names of the previous work to compute the correlation
colorSpaces = {'HSV_CCL_DT' 'HSV_CCL_DT_changed' 'HSV_CCL_DT_templates' 'CCLHSV' 'Global_correlation'};
colorSp = [         1                2                     3                4          5];


[ params, files, templates] = compute_paremeters_w4( directory_results, directory_images, set_type, directory_templates );



%%

metrix_methods = zeros(7, 5);
for i = 1:5
    params.colorSpace = colorSp(i);
    metrix = SignDetection_Pixel_Evaluation_W4(params, files);
    if ~isempty(metrix)
        metrix_methods(:, i) = metrix;
    end
end
if ~isempty(metrix)
    save(strcat(params.directory_write_results, '/metrix_methods_', params.type_set, '_DT'), 'metrix_methods');
end
sprintf(params.type_set)