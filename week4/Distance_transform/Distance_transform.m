function [empty] = Distance_transform(params, files)
    value = num2cell(zeros( 1000, 1));
    BBox = struct('x', value, 'y', value, 'w',value, 'h', value);

%For each image, do something
for i = 1:size(files, 1)
    
imagename = char(files(i).name);
sprintf(imagename)
mask = imread(strcat(params.directory_read_mask, imagename,'_morf.png'));

load(strcat(params.directory_read_BBox, imagename,'_mask.mat')); 


image_canny = edge(mask,'canny');

distance = bwdist(image_canny);
distance = distance/max(max(distance));
   
%Tolerancia de pixeles
tol=10;

sumCircle_signal = zeros(5,441);
sumTriangle_signal = zeros(5,441);
sumTriangleInv_signal = zeros(5,441);
sumSquare_signal = zeros(5,441);

idx = 1;

    for n_BBox = 1:size(windowCandidates,1)
    % Resize the template to fit with the window
%     template_rCircle = imresize(template,[windowC.h,windowC.w]);
%     template_rTriangle = imresize(template,[windowC.h,windowC.w]);
%     template_rTriangleInv = imresize(template,[windowC.h,windowC.w]);
%     template_rSquare = imresize(template,[windowC.h,windowC.w]);

    template_rCircle = Template(1,[windowCandidates.h,windowCandidates.w]);
    template_rTriangle = Template(3,[windowCandidates.h,windowCandidates.w]);
    template_rTriangleInv = Template(4,[windowCandidates.h,windowCandidates.w]);
    template_rSquare = Template(2,[windowCandidates.h,windowCandidates.w]);

        for tol_y = windowCandidates.y-tol:windowCandidates.y+tol
            for tol_x = windowCandidates.x-tol:windowCandidates.x+tol  
                
                Circle_signal = template_rCircle.*distance(tol_y+1:tol_y+size(template_rCircle,1),...
                    tol_x+1:tol_x+size(template_rCircle,2));
                
                sumCircle_signal(1,idx) = sum(sum(Circle_signal));
                sumCircle_signal(2,idx) = tol_x;
                sumCircle_signal(3,idx) = tol_y;
                sumCircle_signal(4,idx) = windowCandidates.h;
                sumCircle_signal(5,idx) = windowCandidates.w;
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
                sumTriangleInv_signal(4,idx) = windowCandidates.h;
                sumTriangleInv_signal(5,idx) = windowCandidates.w;
%                 sumTriangleInv_signal(1,idx) = sum(sum(TriangleInv_signal));

                Square_signal = template_rSquare.*distance(tol_y+1:tol_y+size(template_rSquare,1),...
                    tol_x+1:tol_x+size(template_rSquare,2));
                
                sumSquare_signal(1,idx) = sum(sum(Square_signal));
                sumSquare_signal(2,idx) = tol_x;
                sumSquare_signal(3,idx) = tol_y;
                sumSquare_signal(4,idx) = windowCandidates.h;
                sumSquare_signal(5,idx) = windowCandidates.w;
%                 sumSquare_signal(1,idx) = sum(sum(Square_signal));

                idx = idx + 1;

            end
        end
    
        [C,c] = min(sumCircle_signal(1,:));
        [T,t] = min(sumTriangle_signal(1,:));
        [TI,ti] = min(sumTriangleInv_signal(1,:));
        [S,s] = min(sumSquare_signal(1,:));
        
        [min_Signal, type_sign] = min([C, T, TI,S]);
%         [min_Signal, type_sign] = min([min(sumCircle_signal(1,:)), min(sumTriangle_signal(1,:)), min(sumTriangleInv_signal(1,:)),min(sumSquare_signal(1,:))]);

        if min_Signal < 15
            switch type_sign
                case 1

                BBox(n_BBox).y = sumCircle_signal(3,c);
                BBox(n_BBox).x = sumCircle_signal(2,c);
                BBox(n_BBox).w = sumCircle_signal(5,c);
                BBox(n_BBox).h = sumCircle_signal(4,c);
                
                case 2

                BBox(n_BBox).y = sumTriangle_signal(3,t);
                BBox(n_BBox).x = sumTriangle_signal(2,t);
                BBox(n_BBox).w = sumTriangle_signal(5,t);
                BBox(n_BBox).h = sumTriangle_signal(4,t);
                
                case 3
                    
                BBox(n_BBox).y = sumTriangleInv_signal(3,ti);
                BBox(n_BBox).x = sumTriangleInv_signal(2,ti);
                BBox(n_BBox).w = sumTriangleInv_signal(5,ti);
                BBox(n_BBox).h = sumTriangleInv_signal(4,ti);
                
                case 4
                    
                BBox(n_BBox).y = sumSquare_signal(3,s);
                BBox(n_BBox).x = sumSquare_signal(2,s);
                BBox(n_BBox).w = sumSquare_signal(5,s);
                BBox(n_BBox).h = sumSquare_signal(4,s);
           end

        end
    end
    save(strcat(params.directory_write_results, '/', imagename, '_boxes.mat'), 'BBox');
end
empty = [];
end

