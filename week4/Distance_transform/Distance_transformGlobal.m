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
    
    % Diferentes tamaños de templates para escoger 1
    for windowSize = 1:5
        h = windowSize*15;
        w = h;
        templateC = Template(1, [h,w]);
        templateT = Template(3, [h,w]);
        templateiT = Template(4, [h,w]);
        templateS = Template(2, [h,w]);
        %detecciones = 1000*ones(dim_mask,5,2);
 
        
%         limit_left = max(1, y - tol);
%         limit_right = min(dim_mask(1), y + h + tol) - h; 
%         limit_up = max(1, x - tol);
%         limit_down = min(dim_mask(2), x + w + tol) - w;
%         
%         for tol_y = limit_left:limit_right
%             for tol_x = limit_up:limit_down
%                 
%      
% 
%         
%                 template_rCircle.*distance(tol_y + 1:tol_y + h, tol_x + 1:tol_x + w)
        
        % Recorre la imagen
            for y = 1:dim_mask(1) - h
                for  x = 1:dim_mask(2) - w
                    % Si no hay ningun cero seguro que no hay señal y pasa al
                    % siguiente pixel
                    if (nnz(mask(y:y+w,x:x+h)) ~= 0)

                         circle = templateC.*distance(y:y+w-1,x:x+h-1);
                         square = templateS.*distance(y:y+w-1,x:x+h-1);
                         triang = templateT.*distance(y:y+w-1,x:x+h-1);
                         itrian = templateiT.*distance(y:y+w-1,x:x+h-1);

                         mayC = sum(circle(:));
                         mayS = sum(square(:));
                         mayT = sum(triang(:));
                         mayI = sum(itrian(:));

                         [value, type] = min([mayC, mayS, mayT, mayI]);
                         % mismo tamaño de la imagen y una mas para guardar cada punto
        %                  detecciones(:,:,1) = [value,type];

        %                  detection(:,:,1) = [y,x];
        %                  detection(:,:,2) = [h,w];
        %                  detection(:,:,3) = [0,value];
        %                  detection(:,:,4) = [0,type];

                         detection.coordinates = [y,x];
                         detection.windosSize  = [h,w];
                         detection.value = value;
                         detection.type = type;
                         
                         detected(detection.coordinates(1),detection.coordinates(2)) =...
                         detection.value < distance_tolerance;

                    end
                end
            end   
        save(strcat(params.directory_write_results, '/', imagename, '_mask.png'), 'detected');
    end
end
empty = [];
end
