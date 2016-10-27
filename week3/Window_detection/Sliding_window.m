% function [empty] = Sliding_window( path_images_read, directory_write, pixel_method, SC_train )

window_size = 15;
step_window = 1;

validation_crit = Validation_criteria( SC_train );

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

% for i = 1:size(SC_train, 1)
    value = num2cell(zeros( 50, 1));

    BBox = struct('x', value, 'y', value, 'w',value, 'h', value);
    idx_BB = 1;
    i = 1;
    imagename = char(SC_train(i, 1));
    Mask = imread(strcat(path_images_read, imagename,'_morf.jpg'));
    Mask = Mask/max(Mask(:));
    dim = size(Mask);
    for j = 1:step_window:(dim(1) - window_size)
        for k = 1:step_window:(dim(2) - window_size)
            
            Window = Mask(j:window_size + j, k:window_size + k);
            validate = Validate_window(Window, validation_crit);
            
            if validate
                
                BBox(idx_BB).x = j;
                BBox(idx_BB).y = k;
                BBox(idx_BB).w = window_size;
                BBox(idx_BB).h = window_size;
                idx_BB = idx_BB + 1;
                
            end
        end
    end
    BBox(idx_BB + 1:50) = [];
%     BBox = Clear_overlap(BBox);
%     save(strcat(directory_write, '/', imagename, '_boxes'), 'BBox');
% end
empty = [];
% end

