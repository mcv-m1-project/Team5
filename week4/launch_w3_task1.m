% clear all
% close all
% clc
% addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';

%Set to evaluate: train, validate or test
set_type = 'train';

%Names of the different methods we have used for the segmentation
colorSpaces = { 'HSV'  'HSV&RGB' };
colorSp = [       1        2    ];

[ params, files, SC_train ] = compute_paremeters_w3( directory_results, directory_images, set_type );

%%

metrix_methods = zeros(7, 2);
for i = 1:2
    params.colorSpace = colorSp(i);
    metrix = SignDetectionCCL( params, files, SC_train );
    if ~isempty(metrix)
        metrix_methods(:, i) = metrix;
    end
end
save(strcat(params.directory_write_results, '/metrix_methods_', params.type_set, '_CCL'), 'metrix_methods');
sprintf(params.type_set)

