%SCRIPT FOR TESTING
clear all; close all;
directory_write = '../Results/week_01';
directory_read_train = '../Images/train';%images dir
addpath('./color_segmentation');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbins=[50,50];%Number of bins for the 2D histogram
histogramBackProjectionTrain(nbins,directory_write,directory_read_train);



load(strcat(directory_write, '/names_files_train'));%Train images
load(strcat(directory_write, '/names_files_validate'));%Validation images


%Train set
%prob_threshold=0.2;%The probability threshold will be this number multiplied by the maximum probability of the array
%histogramBackProjectionSegmentation(prob_threshold,files_train,directory_read_train,directory_write);
threshold=0.00006;%Between 0 and 1
circle_radius=3;%Radius of the circle to convolve
directory_write = '../Results/week_01/train_result';
histogramBackProjectionSegmentation2(threshold,circle_radius,files_train,directory_read_train,directory_write);


%Validation set
directory_write = '../Results/week_01/validate_result';
%histogramBackProjectionSegmentation(prob_threshold,files_validate,directory_read_train,directory_write);
histogramBackProjectionSegmentation2(threshold,circle_radius,files_validate,directory_read_train,directory_write);
