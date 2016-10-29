function [empty] = Sliding_window( path_images_read, directory_write, pixel_method, SC_train )


step_window = 5;

[ Characteristics ] = trainSC_Window( SC_train );

% switch pixel_method
%     case 1
%         path_images_read = strcat(path_images_read, '/week_02/train_result/RGBManual/');
%     case 2
%         path_images_read = strcat(path_images_read, '/week_02/train_result/HSV/');
%     case 3
%         path_images_read = strcat(path_images_read, '/week_02/train_result/YUV/');
%     case 4
%         path_images_read = strcat(path_images_read, '/week_02/train_result/HSV&RGB/');
%     case 5
%         path_images_read = strcat(path_images_read, '/week_02/train_result/histBP/');
% end



%For each iamge, compute windows
for i = 1:size(SC_train, 1)
    samples = 1000;
    value = num2cell(zeros( samples, 1));
    
    BBox = struct('x', value, 'y', value, 'w',value, 'h', value);
    idx_BB = 1;
    
    imagename = char(SC_train(i, 1));
    Mask = imread(strcat(path_images_read, imagename,'_morf.jpg'));
    Mask = Mask/max(Mask(:));
    %We will compute different type of windows for each type of signal,
    %because they have different form factor. t correponds to the type of
    %sign: 1-triangle, 2-circle and 3-square
    for t = 1:3
        width_sizes = Characteristics(t).min_w:step_window:Characteristics(t).max_w;
        if width_sizes(end) < Characteristics(t).max_w
            width_sizes = [width_sizes Characteristics(t).max_w];
        end
        height_sizes = Characteristics(t).mean_form_factor*width_sizes;
        for n = size(width_sizes, 1);
            %For each size of window, find signs
            window_width = width_sizes(n);
            window_height = height_sizes(n);
            
            dim = size(Mask);
            for j = 1:step_window:(dim(1) - window_width)
                for k = 1:step_window:(dim(2) - window_height)
                    
                    Window = Mask(j:window_width + j, k:window_height + k);
                    validate = Validate_window(Window, Characteristics(t));
                    
                    if validate
                        
                        BBox(idx_BB).x = j;
                        BBox(idx_BB).y = k;
                        BBox(idx_BB).w = window_width;
                        BBox(idx_BB).h = window_size;
                        idx_BB = idx_BB + 1;
                        
                    end
                end
            end
            BBox(idx_BB:length(BBox)) = [];
            
        end
    end
    
    BBox = Clear_overlap(BBox);
    windowCandidates = BBox;
    %     save(strcat(directory_write, '/', imagename, '_boxes'), 'windowCandidates');
end
empty = [];
end

