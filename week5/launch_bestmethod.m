clear all
close all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';

%Set to evaluate: train, validate or test
set_type = 'validate';

%%
%Segmentation

colorSp = 7;%Chosen segmentation method: histBP
[ params, files] = compute_paremeters_w1( directory_results, directory_images, set_type );

params.colorSpace = colorSp;
metr_method = SignDetection(params, files);

%%

%Morphological operators
colorSp = 5;%Chosen segmentation method: histBP
[ params, files] = compute_paremeters_w2( directory_results, directory_images, set_type );

params.colorSpace = colorSp;
metr_method = SignDetection_t3w2(params, files);


%%

%CCL
colorSp =3;%Chosen segmentation method: histBP
[ params, files, SC_train ] = compute_paremeters_w3( directory_results, directory_images, set_type );

params.colorSpace = colorSp;
metr_method = SignDetectionCCL( params, files, SC_train );
save(strcat(params.directory_write_results, '/metrix_methods_', params.type_set, '_CCL_hbp'), 'metr_method');