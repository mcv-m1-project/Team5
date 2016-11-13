function [finalWindowCandidates] = UCM(params, files, SC_train)
%directory_results = '/Users/lidiatalavera/Desktop/Resultados/';
%directory_images = '/Users/lidiatalavera/Desktop/Images/train/';
%files= dir([directory_images '/*.jpg']);

    for j = 1:size(files, 1)

        imagename = char(files(j).name);
        sprintf(imagename)
        I = imread(strcat(params.directory_read_images, imagename,'.jpg'));
        
       % hsv_image = rgb2hsv(I);
        seg = segment_ucm(I, 0.8);
        Unique_img = unique(seg);
        aux_img2=zeros(size(seg));
        train_param = trainSignCharacteristicsCCL(SC_train);

        for i=1:length(Unique_img)
            aux_img = seg==i;
            CC = bwconncomp(aux_img);
            windowProps=regionprops(CC,'All');

            fr=windowProps.FilledArea/(windowProps.BoundingBox(3)*windowProps.BoundingBox(4));%Filling ratio
            ff = windowProps.BoundingBox(3)/windowProps.BoundingBox(4);
            if windowProps.Area >= train_param.minarea && windowProps.Area <= train_param.maxarea...
                    && ff >= train_param.minff && ff <= train_param.maxff...
                    && fr >= train_param.minfr && fr <= train_param.maxfr...
                    
                aux_img2 = aux_img|aux_img2;
                
            end   
        end
         
    finalWindowCandidates = CCL(aux_img2,train_param);
  
    save(strcat(params.directory_write_results,'/', files(j).name, '_mask.mat'), 'finalWindowCandidates');
    new_mask = create_mask_of_window( finalWindowCandidates, aux_img2 );
    imwrite(new_mask, strcat(params.directory_write_results, '/', files(j).name, '_mask.png'));
    end
end