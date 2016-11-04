%Task 1 w4
clear all; close all;

% siz=[20,20];
% 
% circle = template_model1(siz);
% figure();
% imshow(circle);
% 
% square = template_model2(siz);
% figure();
% imshow(square);
% 
% triangle = template_model3(siz);
% figure();
% imshow(triangle);
% 
% itriangle = template_model4(siz);
% figure();
% imshow(itriangle);

%%%%%%%%%%%%%%%%%%%%%%%
directory_templates = '../../Results/week_04/Templates';
directory_train_images='../../Images/train';
directory_write_results='../../Results/week_04/train_result';
if ~exist(directory_templates, 'dir')
  mkdir(directory_templates);
end
%%%%%%%%%%%%%%%%%%%%%%%

%Create mean grayscale image for each group

load('../../Results/week_01/Sign_characteristics_train');
G = unique(SC_train(:,5));%Sign groups

templates=cell(length(G),1);%D
for i=1:length(G)
    indexs=not(cellfun('isempty', strfind(SC_train(:,5), G{i})));
    SC_group=SC_train(indexs,:);
    meanModel = ComputeMeanGrayImageForSignGroup(SC_group,directory_train_images);
    figure(); imshow(meanModel);
    imwrite(meanModel,strcat(directory_templates,filesep,'Template',G{i},'.png'));
    
    templates{i}=meanModel;
end


%Load templates
%TODO

if ~exist(strcat(directory_write_results,'/TM_Correlation_Global'), 'dir')
  mkdir(strcat(directory_write_results,'/TM_Correlation_Global'));
end
%Compare images with templates: Global approach
for i=1:length(SC_train)
    im=double(rgb2gray(imread(strcat(directory_train_images,filesep,SC_train{i,1},'.jpg'))));
    [windowCandidates,mask]=TemplateMatchingCorrelationGlobal(im,templates);
    
    save(strcat(directory_write_results,'/TM_Correlation_Global',filesep,SC_train{i,1}, '_mask.mat'), 'windowCandidates');
    imwrite(mask, strcat(directory_write_results,'/TM_Correlation_Global',filesep,SC_train{i,1},'_mask.png'));
end

%Compare images with templates: CCL
for i=1:length(SC_train)
    im=double(rgb2gray(imread(strcat(directory_train_images,filesep,SC_train{i,1},'.jpg'))));
    windowCandidates=TemplateMatchingCorrelationCCL(im);
end
