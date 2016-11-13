function [ empty ] = Hough_detection( params, files, SC_train )


Thresholds = Thresholds_hough( SC_train );

for n = 1:size(files, 1)
    %     n = 34;
    %Read image
    imagename = char(files(n).name);
    sprintf(imagename)
    
    image = rgb2gray(imread(strcat(params.directory_read_images, imagename, '.jpg')));
    %Read image from colorspace
    mask_original = imread(strcat(params.directory_read_mask, imagename,'_mask.png'));
    %Read image from CCL window method
    load(strcat(params.directory_read_window, imagename,'_mask.mat'));
    
    
    dim_mask = size(mask_original);
    mask_edges = edge(mask_original,'canny');
    
    value = num2cell(zeros( size(windowCandidates,1), 1));
    
    BBox_final = struct('x', value, 'y', value, 'w',value, 'h', value);
    idx_BB = 1;
    
    for n_BBox = 1:size(windowCandidates,1)
        
        triangle_detected = 0;
        rectangle_detected = 0;
        circle_detected = 0;
        
        %for each BBox, compute the Hough transform
        %Dimensions of the window
        y = windowCandidates(n_BBox).y;
        x = windowCandidates(n_BBox).x;
        w = windowCandidates(n_BBox).w;
        h = windowCandidates(n_BBox).h;
        Window = padarray(mask_edges(y:min(h + y, dim_mask(1)), x:min(w + x, dim_mask(2))), [10 10]);
        
        [HT, theta, ~] = hough(Window);
        
        
        %Determine the peaks using T_c (we will allow maximum 10 peaks)
        Peaks = houghpeaks(HT, 10, 'Threshold', Thresholds.T_c);
        %         if ~isempty(Peaks)
        %             lines = houghlines(Window, theta, rho, Peaks, 'FillGap', 8, 'MinLength', Thresholds.min_D_rect*4/4);
        
        horizontal = zeros(size(lines, 1), 1);
        vertical = zeros(size(lines, 1), 1);
        inclined = zeros(size(lines, 1), 1);
        
        idx_h = 0;
        idx_v = 0;
        idx_i = 0;
        
        angle = theta + 90;
        
        triangle_detected = 0;
        rectangle_detected = 0;
        circle_detected = 0;
        
        for i = 1:size(Peaks, 1)
            %We will classify the obtained lines into three types:
            %-Horizontal: 0 degrees angle
            %-Vertical: 90 degrees angle
            %-Inclined: 60 degrees angle
            
            %Transform from theta to the angle of the line
            
            
            if abs(angle(Peaks(i, 2))) < Thresholds.T_theta_h
                
                idx_h = idx_h + 1;
                horizontal(idx_h) = i;
                
            elseif abs(abs(angle(Peaks(i, 2))) - 90) < Thresholds.T_theta_v
                
                idx_v = idx_v + 1;
                vertical(idx_v) = i;
                
            elseif abs(abs(angle(Peaks(i, 2))) - 60) < Thresholds.T_theta_i
                
                idx_i = idx_i + 1;
                inclined(idx_i) = i;
                
            end
        end
        
        vertical(idx_v + 1:end) = [];
        horizontal(idx_h + 1:end) = [];
        inclined(idx_i + 1:end) = [];
        
        %When we have classified the segments, we will decide if the
        %segments are a shape or not
        
        %Rectangle: 2 vertical and 2 horizontal
        if length(vertical) >= 2
            if length(horizontal) >= 2
                rectangle_detected = 1;
            end
        end
        
        %Triangle: 1 horizontal and 2 inclined of different orientation
        if length(horizontal) >= 1
            if length(inclined) >= 2
                angle_inclined = angle(Peaks(inclined, 2));
                pos = angle_inclined > 0;
                neg = angle_inclined < 0;
                if length(pos) > 1 && length(neg)  > 1
                    triangle_detected = 1;
                end
            end
        end
        
        %Compute the circular hough transform
        if w > 32 && h > 32
            %         Window = 255*double(padarray(mask_original(y:min(h + y, dim_mask(1)), x:min(w + x, dim_mask(2))), [10 10]));
            %         Window = double(padarray(image(y:min(h + y, dim_mask(1)), x:min(w + x, dim_mask(2))), [10 10]));
            Window = imresize(double(image(y:min(h + y, dim_mask(1)), x:min(w + x, dim_mask(2)))), [max(w, h) max(w, h)]);
            
            min_rad = round(min(h, w)/4);%??
            max_rad = round(max(h, w));%??
            radrange = [min_rad max_rad];
            [~, ~, cirrad] = CircularHough_Grd(Window, radrange);
            if ~(isempty(cirrad))
                circle_detected = 1;
            end
        end
        if triangle_detected || rectangle_detected || circle_detected
            %If a shape has been detected, save the BBox
            BBox_final(idx_BB).y = windowCandidates(n_BBox).y;
            BBox_final(idx_BB).x = windowCandidates(n_BBox).x;
            BBox_final(idx_BB).w = windowCandidates(n_BBox).w;
            BBox_final(idx_BB).h = windowCandidates(n_BBox).h;
            idx_BB = idx_BB + 1;
        end
    end
    BBox_final(idx_BB:end, :) = [];
    windowCandidates = BBox_final;
    new_mask = create_mask_of_window( windowCandidates, mask_original );
    imwrite(new_mask, strcat(params.directory_write_results, '/', imagename, '_mask.png'));
    save(strcat(params.directory_write_results, '/', imagename, '_mask.mat'), 'windowCandidates');
end
empty = [];
end





















% for i = 1:size(Peaks, 1)
%             for j = i + 1:size(Peaks, 1)
%                 theta_i = theta(Peaks(i, 2));
%                 theta_j = theta(Peaks(j, 2));
%
%                 % first we will look at its paralelism
%                 Delta_theta_rectangle = abs(theta_i - theta_j);
%                 if Delta_theta_rectangle < Thresholds.T_theta_rectangle
%
%                     %for each pair founded, compute P_k
%                     P_k_rectangle(idx_p_k, 1 ) = 0.5*(theta_i + theta_j);
%
%                     P_k_rectangle(idx_p_k, 2 ) = Delta_theta_rectangle;
%
%                     P_k_rectangle(idx_p_k, 3 ) = i;
%                     P_k_rectangle(idx_p_k, 4 ) = j;
%
%                     %Save all rho and theta values
%                     P_k_rectangle(idx_p_k, 5 ) = theta_i;
%                     P_k_rectangle(idx_p_k, 6 ) = theta_j;
%
%                     idx_p_k = idx_p_k + 1;
%                 else
%                     %If they are not paralel, we will see if they form a
%                     %60º anglle
%                     Delta_theta_triangle = abs(abs(theta_i - theta_j) - 60);
%                     if Delta_theta_triangle < Thresholds.T_theta_triangle
%                         %If they do, we will try to find the third vertex
%                         %of the triangle
%                         for r = j + 1:size(Peaks,1)
%
%                             theta_r = theta(Peaks(r, 2));
%                             Delta_theta_r1 = abs(abs(theta_i - theta_r) - 60);
%                             Delta_theta_r2 = abs(abs(theta_j - theta_r) - 60);
%                             if Delta_theta_r1 < Thresholds.T_theta_triangle || Delta_theta_r2 < Thresholds.T_theta_triangle
%                                 %We have found a triangle
%                                 triangle_detected = 1;
%                             end
%                         end
%                     end
%                 end
%             end
%         end
%         P_k_rectangle(idx_p_k:end, :) = [];
%         for k = 1:idx_p_k - 1
%             for l = k + 1:idx_p_k - 1
%                 %for each P_k, find pairs with angle less than T_alpha
%                 Delta_alpha = abs(abs(P_k_rectangle(k, 1) - P_k_rectangle(l, 1)) - 90);
%                 if Delta_alpha < Thresholds.T_alpha;
%                     rectangle_detected = 1;
%                 end
%             end
%         end
