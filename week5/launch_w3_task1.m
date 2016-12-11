clear all
close all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';

%Set to evaluate: train, validate or test
set_type = 'train';

%Names of the different methods we have used for the segmentation
colorSpaces = { 'HSV'  'HSV&RGB' 'histBP'};
colorSp = [       1                ];

[ params, files, SC_train ] = compute_paremeters_w3( directory_results, directory_images, set_type );

%%
% files = files(45);
metrix_methods = zeros(7, length(colorSp));
for i = 1:length(colorSp)
    params.colorSpace = colorSp(i);
    sprintf(colorSpaces{i})
    metrix = SignDetectionCCL( params, files, SC_train );
    metrix_pixel = SignDetectionSW_pixel_ev( params, files );
    if ~isempty(metrix)
        metrix_methods(:, i) = metrix;
    end
end
save(strcat(params.directory_write_results, '/metrix_methods_', params.type_set, '_CCL'), 'metrix_methods');
sprintf(params.type_set)

%Precision Recall curve
f = Recall_Precision_Curve(colorSpaces,metrix_methods(3,:),metrix_methods(1,:));
saveas(f, strcat(params.directory_write_results,filesep,'PrecisionRecall.png'));