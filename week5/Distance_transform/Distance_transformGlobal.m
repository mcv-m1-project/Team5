function [empty] = Distance_transformGlobal(params, files)

%Threshold to discard regions that are not signal
distance_tolerance = 2;

%For each image, do something
for i = 1:size(files, 1)
     
    %Create variable to save results
    value = num2cell(zeros( 1000, 1));
    BBox = struct('x', value, 'y', value, 'w',value, 'h', value);
    idx_BBox = 1;
    
    imagename = char(files(i).name);
    sprintf(imagename)
    mask = imread(strcat(params.directory_read_mask, imagename,'_morf.png'));
    dim_mask = size(mask);
    detected = zeros(dim_mask(1),dim_mask(2));
    image_canny = edge(mask,'canny');
    distance = bwdist(image_canny);
    distance = distance/max(distance(:));
    
    idx = 1;
    
    % Diferentes tama�os de templates para escoger 1
    for windowSize = 1:5
        h = windowSize*15;
        w = h;
        templateC = Template(1, [h,w]);
        templateT = Template(3, [h,w]);
        templateiT = Template(4, [h,w]);
        templateS = Template(2, [h,w]);

        idx_pixel_candidate = 1;
        % Recorre la imagen
            for y = 1:dim_mask(1) - h
                for  x = 1:dim_mask(2) - w
                    % Si no hay ningun cero seguro que no hay se�al y pasa al
                    % siguiente pixel
                    if (nnz(mask(y:y+w,x:x+h)) ~= 0)
                         idx_pixel_candidate = idx_pixel_candidate + 1;
                        
                         circle = templateC.*distance(y:y+w-1,x:x+h-1);
                         square = templateS.*distance(y:y+w-1,x:x+h-1);
                         triang = templateT.*distance(y:y+w-1,x:x+h-1);
                         itrian = templateiT.*distance(y:y+w-1,x:x+h-1);

                         mayC = sum(circle(:));
                         mayS = sum(square(:));
                         mayT = sum(triang(:));
                         mayI = sum(itrian(:));

                         [value, type] = min([mayC, mayS, mayT, mayI]);
                         % mismo tama�o de la imagen y una mas para guardar cada punto
        %                  detecciones(:,:,1) = [value,type];

        %                  detection(:,:,1) = [y,x];
        %                  detection(:,:,2) = [h,w];
        %                  detection(:,:,3) = [0,value];
        %                  detection(:,:,4) = [0,type];

                         detection(idx_pixel_candidate).coordinates = [y,x];
                         detection(idx_pixel_candidate).windowsize  = [h,w];
                         detection(idx_pixel_candidate).value = value;
                         detection(idx_pixel_candidate).type = type;
                         
                         detected(detection(idx_pixel_candidate).coordinates(1),detection(idx_pixel_candidate).coordinates(2)) =...
                         detection(idx_pixel_candidate).value < distance_tolerance;
                            
                            if(detected(y,x) ==1)
                                  
                                BBox(idx_BBox).y = y;
                                BBox(idx_BBox).x = x;
                                BBox(idx_BBox).w = w;
                                BBox(idx_BBox).h = h;
                                idx_BBox = idx_BBox + 1;

                            end
                    end
                end
            end
        BBox(idx_BBox:end) = [];
        windowCandidates = BBox;
        new_mask = create_mask_of_window( windowCandidates, mask );
        imwrite(new_mask, strcat(params.directory_write_results,  imagename, '_','mask.png'));
        save(strcat(params.directory_write_results, imagename, '_', 'mask.mat'), 'windowCandidates');
    
end
empty = [];
end
