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

colorSp = [3 7];%Chosen segmentation method: HSV histBP
[ params, files] = compute_paremeters_w1( directory_results, directory_images, set_type );
for i = 1:length(colorSp)
    params.colorSpace = colorSp(i);
    metr_method = SignDetection(params, files);
end
%%

%Morphological operators
colorSp = [2 5];%Chosen segmentation method: HSV histBP
[ params, files] = compute_paremeters_w2( directory_results, directory_images, set_type );
for i = 1:length(colorSp)
    params.colorSpace = colorSp(i);
    metr_method = SignDetection_t3w2(params, files);
end

%%

%CCL
colorSp =[1 3];%Chosen segmentation method: HSV histBP
[ params, files, SC_train ] = compute_paremeters_w3( directory_results, directory_images, set_type );

for i = 1:length(colorSp)
    params.colorSpace = colorSp(i);
    metr_method = SignDetectionCCL( params, files, SC_train );
end

%%

%OR

hsvpath=strcat('../Results/week_03/',set_type,'_result/HSV_CCL');
hsvfiles=dir(strcat(hsvpath,'/*.png'));

hbppath=strcat('../Results/week_03/',set_type,'_result/histBP_CCL');
hbpfiles=dir(strcat(hbppath,'/*.png'));

writepath=strcat('../Results/week_05/',set_type,'_result/best_approach');
if ~exist(writepath , 'dir')
    mkdir(writepath);
end

for i=1:length(hsvfiles)
    hsvmask = logical(double(imread(strcat(hsvpath, filesep, hsvfiles(i).name))));
    hbpmask = logical(double(imread(strcat(hbppath, filesep, hbpfiles(i).name))));
    newmask=double(hsvmask|hbpmask);
    imwrite(newmask,strcat(writepath,filesep,hsvfiles(i).name));
end

%%

%Metrics

metrix_method = metrics_pixel(writepath,strcat(directory_images,filesep,'train'));

save(strcat(writepath, '/metrix_methods_', params.type_set, '_bestapproach'), 'metrix_method');

