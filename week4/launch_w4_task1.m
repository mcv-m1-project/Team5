clear all
close all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';
directory_templates = '../Results/week_04/Templates';

%Set to evaluate: train, validate or test
set_type = 'train';

%Names of the previous work to compute the correlation
methods = {  };
% = { 'HSV'  'HSV&RGB' };
meth = [    ];
% = [       1        2    ];

[ params, files, templates] = compute_paremeters_w4( directory_results, directory_images, set_type, directory_templates );


%%

metrix_methods = zeros(7, ??);
for i = 1:2
    params.colorSpace = colorSp(i);
    metrix = SignDetectionCorrelation( params, files, Templates );
    if ~isempty(metrix)
        metrix_methods(:, i) = metrix;
    end
end
if ~isempty(metrix)
    save(strcat(params.directory_write_results, '/metrix_methods_', params.type_set, '_corr'), 'metrix_methods');
end
sprintf(params.type_set)