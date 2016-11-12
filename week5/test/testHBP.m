%%%TEST HBP
clear all;close all;
addpath(genpath('..'))

directory_results = '../../Results';
directory_images = '../../Images';

%Set to evaluate: train, validate or test
set_type = 'validate';


%%
%Values to test
A=[0.00006 0.00005 0.00004 0.00003 0.00002 0.00001];%threshold
C=[2];%radio
B=[30];%bins
tests=combvec(A,B,C);

%Evaluate all methods ans save its metrices 
metrix_methods = zeros(10, length(tests));

for i = 1:length(tests)
    [ params, files] = compute_paremeters_w1test( directory_results, directory_images, set_type,tests(2,i));
    
    params.colorSpace = 7;%HBP
    metr_method = SignDetectiontest(params, files,tests(1,i),tests(3,i));

    if ~isempty(metr_method)
        metrix_methods(:, i) = metr_method;
        metrix_methods(1:4, :)
    end
end

if ~strcmp(params.type_set, 'test')
    save(strcat(params.directory_write_results, '/metrix_FBP_test'), 'metrix_methods');
end 

%Para cada valor del radio un plot
idx=1;
for i=1:length(C)
    
    fm=metrix_methods(4,idx:(idx+length(A)*length(B)-1));
    Z=reshape(fm,[length(A) length(B)]);
    figure(); image(B,A,Z,'CDataMapping','scaled');
    colorbar;
    
    idx=idx+length(A)*length(B);
end