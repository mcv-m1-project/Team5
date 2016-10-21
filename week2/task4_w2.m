clear all; close all;

directory_write = '../Results/week_01';
directory_read_train = '../Images/train/';%images dir
addpath('./color_segmentation');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbins=[100,100];%Number of bins for the 2D histogram
[H2D_group1,H2D_group2,H2D_group3] = histogramBackProjectionTrain(nbins,directory_write,directory_read_train);


%Test images
load(strcat(directory_write, '/Sign_characteristics_validate'));%Validation set
%Writting directory
if ~exist(strcat(directory_write,'/validate_result/histBP'),'dir')
    mkdir(strcat(directory_write,'/validate_result/histBP'));
end

prob_threshold=0.0025;%The probability threshold
%Validation images
for i=1:size(SC_validate,1)
    %Load and convert RGB image to HSV space
    hsvImage = rgb2hsv(imread(strcat(directory_read_train, SC_validate{i,1}, '.jpg')));
    
    %Arrays of probabilities for each group of signs
    P1=zeros(size(hsvImage(:,:,1)));
    P2=zeros(size(hsvImage(:,:,1)));
    P3=zeros(size(hsvImage(:,:,1)));
    
    %For each pixel of the test image
    for j=1:size(hsvImage(:,:,1),1)
        for k=1:size(hsvImage(:,:,1),2)
            hist_Xidx=round(hsvImage(j,k,1)*(nbins(1)-1))+1;
            hist_Yidx=round(hsvImage(j,k,2)*(nbins(2)-1))+1;
            P1(j,k)=H2D_group1(hist_Xidx,hist_Yidx);
            P2(j,k)=H2D_group2(hist_Xidx,hist_Yidx);
            P3(j,k)=H2D_group3(hist_Xidx,hist_Yidx);
        end
    end
    
    maskG1=P1>prob_threshold;
    maskG2=P2>prob_threshold;
    maskG3=P3>prob_threshold;
    Mask=maskG1|maskG2|maskG3;
    
    imwrite(Mask,strcat(directory_write,'/validate_result/histBP/',SC_validate{i,1},'_mask.jpg'));
    
end