function [empty] = Distance_transform_without_edges(params, files)

%Threshold to discard regions that are not signal
distance_tolerance = 2;

%Tolerancia de pixeles
tol = 0;



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
%     original = (imread(strcat(params.directory_read_images, imagename,'.jpg')));
    
    load(strcat(params.directory_read_BBox, imagename,'_mask.mat'));
    
    
    distance = bwdist(mask);
    distance = distance/max(distance(:));
    
    idx = 1;
    %For each windowCandidate from the given method
    for n_BBox = 1:size(windowCandidates,1)
        
        %Dimensions of the window
        y = windowCandidates(n_BBox).y;
        x = windowCandidates(n_BBox).x;
        w = windowCandidates(n_BBox).w;
        h = windowCandidates(n_BBox).h;
        
        % Resize the template to fit with the window
        %     template_rCircle = imresize(template,[windowC.h,windowC.w]);
        %     template_rTriangle = imresize(template,[windowC.h,windowC.w]);
        %     template_rTriangleInv = imresize(template,[windowC.h,windowC.w]);
        %     template_rSquare = imresize(template,[windowC.h,windowC.w]);
        
        %Create template for each shape, accordin to the size of the window
        %to evaluate

        template_rCircle = Template(1, [h, w]);
        template_rTriangle = Template(3, [h, w]);
        template_rTriangleInv = Template(4, [h, w]);
        template_rSquare = Template(2, [h, w]);
        
        
        %We admit that the sign could be better placed 'tol' moved from the
        %original window (in any direction). This are the possible limits
        %for each dimension of the image
        limit_up = max(1, y - tol);
        limit_down = min(dim_mask(1), y + h + tol) - h; 
        limit_left = max(1, x - tol);
        limit_right = min(dim_mask(2), x + w + tol) - w;
        
        for tol_y = limit_up:limit_down
            for tol_x = limit_left:limit_right
                
                window_distance = distance(tol_y + 1:tol_y + h, tol_x + 1:tol_x + w);
                
                Circle_signal = template_rCircle.*window_distance;
                
                sumCircle_signal(1,idx) = sum(Circle_signal(:));
                sumCircle_signal(2,idx) = tol_x;
                sumCircle_signal(3,idx) = tol_y;
                sumCircle_signal(4,idx) = windowCandidates(n_BBox).h;
                sumCircle_signal(5,idx) = windowCandidates(n_BBox).w;
%                 sumCircle_signal(1,idx) = [sum(sum(Circle_signal)) tol_x tol_y windowCandidates.h windowCandidates.w];
                
                Triangle_signal = template_rTriangle.*window_distance;
                
                sumTriangle_signal(1,idx) = sum(Triangle_signal(:));
                sumTriangle_signal(2,idx) = tol_x;
                sumTriangle_signal(3,idx) = tol_y;
                sumTriangle_signal(4,idx) = windowCandidates.h;
                sumTriangle_signal(5,idx) = windowCandidates.w;
                
%                 sumTriangle_signal(1,idx) = sum(sum(Triangle_signal));
                
                TriangleInv_signal = template_rTriangleInv.*window_distance;
                
                sumTriangleInv_signal(1,idx) = sum( TriangleInv_signal(:));
                sumTriangleInv_signal(2,idx) = tol_x;
                sumTriangleInv_signal(3,idx) = tol_y;
                sumTriangleInv_signal(4,idx) = windowCandidates(n_BBox).h;
                sumTriangleInv_signal(5,idx) = windowCandidates(n_BBox).w;
%                 sumTriangleInv_signal(1,idx) = sum(sum(TriangleInv_signal));
                
                Square_signal = template_rSquare.*window_distance;
                
                sumSquare_signal(1,idx) = sum(Square_signal(:));
                sumSquare_signal(2,idx) = tol_x;
                sumSquare_signal(3,idx) = tol_y;
                sumSquare_signal(4,idx) = windowCandidates(n_BBox).h;
                sumSquare_signal(5,idx) = windowCandidates(n_BBox).w;
%                 sumSquare_signal(1,idx) = sum(sum(Square_signal));
                
                idx = idx + 1;
                
            end
        end
        
        [C, c] = min(sumCircle_signal(1, :));
        [T, t] = min(sumTriangle_signal(1, :));
        [TI, ti] = min(sumTriangleInv_signal(1, :));
        [S, s] = min(sumSquare_signal(1, :));
        matches = [C, T, TI,S];
        [min_Signal, type_sign] = min([C, T, TI, S]);
%         [min_Signal, type_sign] = min([min(sumCircle_signal(1,:)), min(sumTriangle_signal(1,:)), min(sumTriangleInv_signal(1,:)),min(sumSquare_signal(1,:))]);
        %If the product with the distance image is smaller than a given
        %threshold, we save the coordinates of the bbox
        if min_Signal < distance_tolerance
            switch type_sign
                case 1
                    
                    BBox(idx_BBox).y = sumCircle_signal(3,c);
                    BBox(idx_BBox).x = sumCircle_signal(2,c);
                    BBox(idx_BBox).w = sumCircle_signal(5,c);
                    BBox(idx_BBox).h = sumCircle_signal(4,c);
                    idx_BBox = idx_BBox + 1;
                    
                case 2
                    
                    BBox(idx_BBox).y = sumTriangle_signal(3,t);
                    BBox(idx_BBox).x = sumTriangle_signal(2,t);
                    BBox(idx_BBox).w = sumTriangle_signal(5,t);
                    BBox(idx_BBox).h = sumTriangle_signal(4,t);
                    idx_BBox = idx_BBox + 1;
                    
                case 3
                    
                    BBox(idx_BBox).y = sumTriangleInv_signal(3,ti);
                    BBox(idx_BBox).x = sumTriangleInv_signal(2,ti);
                    BBox(idx_BBox).w = sumTriangleInv_signal(5,ti);
                    BBox(idx_BBox).h = sumTriangleInv_signal(4,ti);
                    idx_BBox = idx_BBox + 1;
                    
                case 4
                    
                    BBox(idx_BBox).y = sumSquare_signal(3,s);
                    BBox(idx_BBox).x = sumSquare_signal(2,s);
                    BBox(idx_BBox).w = sumSquare_signal(5,s);
                    BBox(idx_BBox).h = sumSquare_signal(4,s);
                    idx_BBox = idx_BBox + 1;
                    
            end
            
        end
        
        
    end
  
    BBox(idx_BBox:end) = [];
    windowCandidates = BBox;
    new_mask = create_mask_of_window( windowCandidates, mask );
    imwrite(new_mask, strcat(params.directory_write_results, '/', imagename, '_mask.png'));
    save(strcat(params.directory_write_results, '/', imagename, '_mask.mat'), 'windowCandidates');

end
empty = [];
end
