function run_TM_Correlation_CCL(templates,directory_write_results,directory_train_images,files,corr_threshold,dir_w3_results,CCL_method)
    if ~exist(strcat(directory_write_results,'/TM_Correlation_',CCL_method), 'dir')
      mkdir(strcat(directory_write_results,'/TM_Correlation_',CCL_method));
    end
    
    %Compare images with templates: CCL
    for i=1:length(files)
        im=rgb2gray(imread(strcat(directory_train_images,filesep,files(i).name,'.jpg')));%Grayscale image
        old_mask=imread(strcat(dir_w3_results,filesep,CCL_method,filesep, files(i).name, '_mask.png'))>0;%CCL mask
        load(strcat(dir_w3_results,filesep,CCL_method, filesep, files(i).name, '_mask.mat'));%CCL windowCandidates

        windowCandidates=TemplateMatchingCorrelationCCL(im,old_mask,windowCandidates,templates,corr_threshold);
        save(strcat(directory_write_results,'/TM_Correlation_',CCL_method,filesep,files(i).name, '_mask.mat'), 'windowCandidates');

        new_mask = create_mask_of_window( windowCandidates, old_mask );
        imwrite(new_mask, strcat(directory_write_results,'/TM_Correlation_',CCL_method,filesep,files(i).name,'_mask.png'));
    end
end