%Task 1 w4
clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%
directory_templates = '../../Results/week_04/Templates';
directory_train_images='../../Images/train';
directory_write_results='../../Results/week_04/train_result';
if ~exist(directory_templates, 'dir')
  mkdir(directory_templates);
end
%%%%%%%%%%%%%%%%%%%%%%%


%Create mean grayscale image for each group using the training set images
load('../../Results/week_01/Sign_characteristics_train');

templates=cell(4,1);
%Groups
G={'CDE','F','A','B'};
for i=1:length(G)
    indexs=zeros(length(SC_train),1);
    for j=1:length(G{i})
        indexsj=not(cellfun('isempty', strfind(SC_train(:,5), G{i}(j))));
        indexs=indexs|indexsj;
    end
    SC_group=SC_train(indexs,:);
    meanModel = ComputeMeanGrayImageForSignGroup(SC_group,directory_train_images);
    imwrite(meanModel,strcat(directory_templates,filesep,'Template',int2str(i),'.png'));
    templates{i}=meanModel;
    %figure();imshow(meanModel);
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




if ~exist(strcat(directory_write_results,'/TM_Correlation_CCL'), 'dir')
  mkdir(strcat(directory_write_results,'/TM_Correlation_CCL'));
end
corr_threshold=.65;
%Compare images with templates: CCL
for i=1:length(SC_train)
    im=rgb2gray(imread(strcat(directory_train_images,filesep,SC_train{i,1},'.jpg')));%Grayscale image
    old_mask=imread(strcat('../../Results/week_03/train_result/HSV_CCL',filesep, SC_train{i,1}, '_mask.png'))>0;%CCL mask
    load(strcat('../../Results/week_03/train_result/HSV_CCL', filesep, SC_train{i,1}, '_mask.mat'));%CCL windowCandidates

    windowCandidates=TemplateMatchingCorrelationCCL(im,old_mask,windowCandidates,templates,corr_threshold);
    save(strcat(directory_write_results,'/TM_Correlation_CCL',filesep,SC_train{i,1}, '_mask.mat'), 'windowCandidates');
    
    new_mask = create_mask_of_window( windowCandidates, old_mask );
    imwrite(new_mask, strcat(directory_write_results,'/TM_Correlation_CCL',filesep,SC_train{i,1},'_mask.png'));
end
