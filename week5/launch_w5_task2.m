clear all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';

%Set to evaluate: train, validate or test
set_type = 'validate';

compute_metrics = 1;

%Names of the previous work to compute the correlation
colorSpaces = {'HSV_CCL', 'HBP_CCL' 'UCM'};
colorSp = [                   2        ] ;


[ params, files, SC_train] = compute_paremeters_w5( directory_results, directory_images, set_type, compute_metrics);



%%

metrix_methods_pixel = zeros(7, length(colorSp));
metrix_methods_region = zeros(7, length(colorSp));
for i = 1:length(colorSp)
    params.colorSpace = colorSp(i);
    metrix_region = SignDetectionHough(params, files, SC_train);
    metrix_pixel  = SignDetectionHough_pixel_ev( params, files );
    if ~isempty(metrix_region)
        metrix_methods_region(:, i) = metrix_region;
        metrix_methods_pixel(:, i) = metrix_pixel;
    end
end
if ~isempty(metrix_region)
    save(strcat(params.directory_write_results, '/metrix_region_', params.type_set, '_Hough'), 'metrix_region');
    save(strcat(params.directory_write_results, '/metrix_pixel_', params.type_set, '_Hough'), 'metrix_pixel');
end
sprintf(params.type_set)