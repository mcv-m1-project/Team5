function run_TM_Correlation_Global(templates,directory_write_results,directory_train_images,files,corr_threshold)
    if ~exist(strcat(directory_write_results,'/TM_Correlation_Global'), 'dir')
      mkdir(strcat(directory_write_results,'/TM_Correlation_Global'));
    end
    %Compare images with templates: Global approach
    for i=1:length(files)
        im=double(rgb2gray(imread(strcat(directory_train_images,filesep,files(i).name,'.jpg'))));
        [windowCandidates,mask]=TemplateMatchingCorrelationGlobal(im,templates,corr_threshold);

        save(strcat(directory_write_results,'/TM_Correlation_Global',filesep,files(i).name, '_mask.mat'), 'windowCandidates');
        imwrite(mask, strcat(directory_write_results,'/TM_Correlation_Global',filesep,files(i).name,'_mask.png'));
    end
end