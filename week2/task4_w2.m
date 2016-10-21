%SCRIPT FOR TESTING
clear all; close all;
directory_write = '../Results/week_01';
directory_read_train = '../Images/train';%images dir
addpath('./color_segmentation');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbins=[50,50];%Number of bins for the 2D histogram
histogramBackProjectionTrain(nbins,directory_write,directory_read_train);


%Train images
load(strcat(directory_write, '/names_files_train'));
prob_threshold=0.2;%The probability threshold will be this number multiplied by the maximum probability of the array
directory_write = '../Results/week_01/train_result';
histogramBackProjectionSegmentation(prob_threshold,files_train,directory_read_train,directory_write);


%Validation images
load(strcat(directory_write, '/names_files_validate'));
directory_write = '../Results/week_01/validate_result';
histogramBackProjectionSegmentation(prob_threshold,files_validate,directory_read_train,directory_write);
