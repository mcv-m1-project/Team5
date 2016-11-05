clear all
close all
clc
addpath(genpath('.'))

%Directory where the masks of the different sets are placed
directory_results = '../Results';
directory_images = '../Images';
directory_templates = '../Results/week_04/Templates';

%Set to evaluate: train, validate or test
set_type = 'test';

%Names of the previous work to compute the correlation
methods = { 'Global' 'CCLHSV'  'CCLHSVRGB'};
meth = [        1       2           3     ];

[params, files, templates] = compute_paremeters_w4( directory_results, directory_images, set_type, directory_templates );

%%
metrix_methods = zeros(7, length(meth));
for i = 1:length(meth)
    params.method = meth(i);
    metrix = SignDetectionCorrelation( params, files, templates);
    if ~isempty(metrix)
        metrix_methods(:, i) = metrix;
    end
end
if ~isempty(metrix)
    save(strcat(params.directory_write_results, '/metrix_methods_', params.type_set, '_corr'), 'metrix_methods');
end
sprintf(params.type_set)