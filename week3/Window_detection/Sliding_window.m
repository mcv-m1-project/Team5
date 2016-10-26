function [empty] = Sliding_window( path_images_read, directory_write, pixel_method, SC_train )

window_size = 5;
step_window = 1;

validation_crit = Validation_criteria( SC_train );

switch pixel_method
    case 1
        path_images_read = strcat(path_images_read, '/week02/RGBManual/');
    case 2
        path_images_read = strcat(path_images_read, '/week02/HSV/');
    case 3
        path_images_read = strcat(path_images_read, '/week02/YUV/');
    case 4
        path_images_read = strcat(path_images_read, '/week02/HSV&RGB/');
    case 5
        path_images_read = strcat(path_images_read, '/week02/histBP/');
end

for i = 1:size(SC_train, 1)
    BBox = zeros(50);
    idx_BB = 1;
    
    imagename = SC_train(i, 1);
    Mask = imread(strcat(path_images_read, imagename,'_morf.jpg'));
    
    dim = size(Mask);
    for j = 1:step_window:(dim(1) - window_size)
        for k = 1:step_window:(dim(2) - window_size)
            
            Window = Mask(j:window_size + j, k:window_size + k);
            validate = Validate_window(Window, validation_crit);
            
            if validate
                
                BBox(idx_BB) = struct(j, k, window_size, window_size);
                idx_BB = idx_BB + 1;
            end
        end
    end
    BBox(idx_BB + 1:50) = [];
    BBox = Clear_overlap(BBox);
    save(strcat(directory_write, '/', imagename, '_boxes'), 'BBox');
end
empty = [];
end

