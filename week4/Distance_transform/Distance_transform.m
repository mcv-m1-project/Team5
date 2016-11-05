function [empty] = Distance_transform(params, files)


%For each image, do something
for i = 1:size(files, 1)
    %Create variable to save results
    value = num2cell(zeros( 1000, 1));
    BBox = struct('x', value, 'y', value, 'w',value, 'h', value);
    idx_BBox = 1;
    
    imagename = char(files(i).name);
    sprintf(imagename)
    mask = imread(strcat(params.directory_read_mask, imagename,'_morf.png'));
    original = (imread(strcat(params.directory_read_images, imagename,'.jpg')));
    
    load(strcat(params.directory_read_BBox, imagename,'_mask.mat'));
    
    
    image_canny = edge(mask,'canny');
    
    distance = bwdist(image_canny);
    distance = distance/max(distance(:));
    
    %Tolerancia de pixeles
    tol = 4;

    idx = 1;
    
    for n_BBox = 1:size(windowCandidates,1)
        %For each windowCaandidate from the given method
        
        % Resize the template to fit with the window
        %     template_rCircle = imresize(template,[windowC.h,windowC.w]);
        %     template_rTriangle = imresize(template,[windowC.h,windowC.w]);
        %     template_rTriangleInv = imresize(template,[windowC.h,windowC.w]);
        %     template_rSquare = imresize(template,[windowC.h,windowC.w]);
        
        template_rCircle = Template(1,[windowCandidates(n_BBox).h,windowCandidates(n_BBox).w]);
        template_rTriangle = Template(3,[windowCandidates(n_BBox).h,windowCandidates(n_BBox).w]);
        template_rTriangleInv = Template(4,[windowCandidates(n_BBox).h,windowCandidates(n_BBox).w]);
        template_rSquare = Template(2,[windowCandidates(n_BBox).h,windowCandidates(n_BBox).w]);
        
        if (windowCandidates(n_BBox).y - tol <= 0||windowCandidates(n_BBox).x - tol <= 0)
            tol = 0;
        end
        
        for tol_y = windowCandidates(n_BBox).y - tol:windowCandidates(n_BBox).y + tol
            for tol_x = windowCandidates(n_BBox).x - tol:windowCandidates(n_BBox).x + tol
                if((tol_y+size(template_rCircle,1)>=size(distance,1)||tol_x+size(template_rCircle,2)>=size(distance,2)))
                    continue;
                end
                
                Circle_signal = template_rCircle.*distance(tol_y+1:tol_y+size(template_rCircle,1),...
                    tol_x+1:tol_x+size(template_rCircle,2));
                
                sumCircle_signal(1,idx) = sum(sum(Circle_signal));
                sumCircle_signal(2,idx) = tol_x;
                sumCircle_signal(3,idx) = tol_y;
                sumCircle_signal(4,idx) = windowCandidates(n_BBox).h;
                sumCircle_signal(5,idx) = windowCandidates(n_BBox).w;
%                 sumCircle_signal(1,idx) = [sum(sum(Circle_signal)) tol_x tol_y windowCandidates.h windowCandidates.w];
                
                Triangle_signal = template_rTriangle.*distance(tol_y+1:tol_y+size(template_rTriangle,1),...
                    tol_x+1:tol_x+size(template_rTriangle,2));
                
                sumTriangle_signal(1,idx) = sum(sum(Triangle_signal));
                sumTriangle_signal(2,idx) = tol_x;
                sumTriangle_signal(3,idx) = tol_y;
                sumTriangle_signal(4,idx) = windowCandidates.h;
                sumTriangle_signal(5,idx) = windowCandidates.w;
                
%                 sumTriangle_signal(1,idx) = sum(sum(Triangle_signal));
                
                TriangleInv_signal = template_rTriangleInv.*distance(tol_y+1:tol_y+size(template_rTriangleInv,1),...
                    tol_x+1:tol_x+size(template_rTriangleInv,2));
                
                sumTriangleInv_signal(1,idx) = sum(sum( TriangleInv_signal));
                sumTriangleInv_signal(2,idx) = tol_x;
                sumTriangleInv_signal(3,idx) = tol_y;
                sumTriangleInv_signal(4,idx) = windowCandidates(n_BBox).h;
                sumTriangleInv_signal(5,idx) = windowCandidates(n_BBox).w;
%                 sumTriangleInv_signal(1,idx) = sum(sum(TriangleInv_signal));
                
                Square_signal = template_rSquare.*distance(tol_y+1:tol_y+size(template_rSquare,1),...
                    tol_x+1:tol_x+size(template_rSquare,2));
                
                sumSquare_signal(1,idx) = sum(sum(Square_signal));
                sumSquare_signal(2,idx) = tol_x;
                sumSquare_signal(3,idx) = tol_y;
                sumSquare_signal(4,idx) = windowCandidates(n_BBox).h;
                sumSquare_signal(5,idx) = windowCandidates(n_BBox).w;
%                 sumSquare_signal(1,idx) = sum(sum(Square_signal));
                
                idx = idx + 1;
                
            end
        end
        
        [C,c] = min(sumCircle_signal(1,:));
        [T,t] = min(sumTriangle_signal(1,:));
        [TI,ti] = min(sumTriangleInv_signal(1,:));
        [S,s] = min(sumSquare_signal(1,:));
        matches = [C, T, TI,S]
        [min_Signal, type_sign] = min([C, T, TI, S]);
%         [min_Signal, type_sign] = min([min(sumCircle_signal(1,:)), min(sumTriangle_signal(1,:)), min(sumTriangleInv_signal(1,:)),min(sumSquare_signal(1,:))]);
        
        if min_Signal < 2
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
