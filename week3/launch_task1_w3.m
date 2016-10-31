clear all; close all;
addpath('./Window_detection');

%Directory where the different methods directories are:
results_dir='../Results/week_02/validate_result';
%Where the mat files are saved (a folder with the method name will be created, if it doesn't exist):
directory_write='../Results/week_03/validate_result';


%Use the training set as a reference for the filling ratio, etc to discard
%false positives
load('../Results/week_01/Sign_characteristics_train');
train_param=trainSignCharacteristicsCCL(SC_train);

 
%Get Bounding Boxes by Connected Component Labeling
methods=dir(results_dir);
for k=3:length(methods)
    mask_files=dir(strcat(results_dir,filesep,methods(k).name,'/*.jpg'));%Get masks
    if ~exist(strcat(directory_write,filesep,methods(k).name, '_CCL'),'dir')
      mkdir(strcat(directory_write,filesep,methods(k).name, '_CCL'));%Directory where the mat files are saved
    end
    
    for i=1:length(mask_files)
        mask = imread(strcat(results_dir,filesep,methods(k).name,filesep,mask_files(i).name));
        windowCandidates = CCL(mask,train_param);
        save(strcat(directory_write,filesep,methods(k).name , '_CCL',filesep,mask_files(i).name(1:end-4),'.mat'), 'windowCandidates');
    end
end
