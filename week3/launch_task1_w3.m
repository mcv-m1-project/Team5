clear all; close all;
addpath('./Window_detection');

%Use the training set as a reference for the filling ratio, etc
%load('../Results/week_01/Sign_characteristics_train');
%TODO

path_masks_read='../Results/week_02/train_result/RGBManual/';
mask_files=dir(strcat(path_masks_read,'*.jpg'));%Get images


i=1;
mask = imread(strcat(path_masks_read, mask_files(i).name));
windowCandidates = CCL(mask);

