function [ empty ] = Hough_detection( params, files, SC_train )


Thresholds = Thresholds_hough( SC_train );


for n = size(files, 1)
    
    %Read image
    imagename = char(files(n).name);
    sprintf(imagename)
    switch params.colorSpace
        case 1
            mask_original = imread(strcat(params.directory_read_mask, imagename,'_mask.png'));
        case 2
            mask_original = imread(strcat(params.directory_read_images, imagename,'.jpg'));
    end
    
    dim_mask = size(mask_original);
    mask_edges = edge(mask_original,'canny');
    
    samples = 1000;
    value = num2cell(zeros( samples, 1));
    
    BBox_final = struct('x', value, 'y', value, 'w',value, 'h', value);
    idx_BB = 1;
    
    for y = 1:dim_mask(1)
        for x = 1:dim_mask(2)
            %(y, x): center of the rectangle
            %for each point, compute the Hough transform of its neighbourhood ring
            up_limit = max(y - Thresholds.max_D_rect, 1);
            down_limit = min(y + Thresholds.max_D_rect, dim_mask(1));
            left_limit = max(x - Thresholds.max_D_rect, 1);
            right_limit = min(x + Thresholds.max_D_rect, dim_mask(2));
            
            Window = mask_edges(up_limit:down_limit, left_limit:right_limit);
            [HT, theta, rho] = hough(Window);
            %Determine the peaks using T_c (we will allow maximum 30 peaks)
            Peaks = houghpeaks(HT, 30, 'Threshold', Thre.T_c);
            P_k = zeros(15, 6);
            idx_p_k = 1;
            for i = 1:size(Peaks, 1)
                for j = i + 1:size(Peaks, 1)
                    rho_i = rho(Peaks(i, 1));
                    theta_i = theta(Peaks(i, 2));
                    
                    rho_j = rho(Peaks(j, 1));
                    theta_j = theta(Peaks(j, 2));
                    
                    Delta_theta = abs(theta_i - theta_j);
                    Delta_rho = abs(rho_i + rho_j);
                    
                    Delta_C_1 = abs(HT(Peaks(i)) - HT(Peaks(j)));
                    Delta_C_2 = (HT(Peaks(i)) + HT(Peaks(j)))/2;
                    
                    %For each peak, find pairs that satisfy some thresholds
                    if Delta_theta < Thresholds.T_theta && Delta_rho < Thresholds.T_rho ...
                            && Delta_C_1 < Thresholds.T_L*Delta_C_2
                        
                        %for each pair founded, compute P_k
                        P_k(idx_p_k, 1 ) = 0.5*abs(rho_i - rho_j);
                        P_k(idx_p_k, 2 ) = 0.5*(theta_i + theta_j);
                        
                        P_k(idx_p_k, 3 ) = Delta_theta;
                        P_k(idx_p_k, 4 ) = Delta_rho;
                        
                        P_k(idx_p_k, 5 ) = i;
                        P_k(idx_p_k, 6 ) = j;
                        
                        idx_p_k = idx_p_k + 1;
                    end
                end
            end
            P_k(idx_p_k:end) = [];
            Rectangle = zeros(6, 1);
            Rectangle(1) = Inf;
            for k = 1:idx_p_k - 1
                for l = k + 1:idx_p_k - 1
                    %for each P_k, find pairs with angle less than T_alpha
                    Delta_alpha = abs(abs(P_k(k, 1) - P_k(l, 1)) - 90);
                    if Delta_alpha < Thresholds.T_alpha;
                        E = sqrt(Thresholds.a*(P_k(k, 3)^2 + P_k(l, 3)^2 + ...
                            Delta_alpha^2) + Thresholds.b*(P_k(k, 4)^2 + P_k(l, 4)^2));
                        %Eliminate repetitions using an energy function
                        if E < Rectangle(1)
                            Rectangle(1) = E;
                            Rectangle(2) = P_k(k, 1);
                            Rectangle(3) = P_k(k, 2);
                            Rectangle(4) = P_k(l, 2);
                        end
                    end
                end
            end
            %Find the rectangle from the given result
            BBox_rectangle = find_rectangle( Rectangle );
            
            BBox_final(idx_BB).y = BBox_rectangle.y;
            BBox_final(idx_BB).x = BBox_rectangle.x;
            BBox_final(idx_BB).w = BBox_rectangle.w;
            BBox_final(idx_BB).h = BBox_rectangle.h;
            idx_BB = idx_BB + 1;
        end
    end
    %Compute the circular hough transform
    img = imread(strcat(params.directory_read_images, imagename,'.jpg'));
    [~, circen, cirrad] = CircularHough_Grd(img, radrange);
    num_circles = length(cirrad);
    for i = 1:num_circles
        %Construct the BBox of the rectangle
        BBox_final(idx_BB).y = 0;
        BBox_final(idx_BB).x = 0;
        BBox_final(idx_BB).w = 0;
        BBox_final(idx_BB).h = 0;
        idx_BB = idx_BB + 1;
    end
end
empty = [];
end

