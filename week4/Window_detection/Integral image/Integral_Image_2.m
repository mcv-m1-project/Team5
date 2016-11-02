function [] = Integral_Image_2(params, files, Characteristics )
% params = struct('directory_read_mask', '', 'directory_read_BBox', '', ...
%     'directory_write_results', '', 'type_set', '', 'colorSpace', 0);

step_window = 5;


%For each image, compute windows
for j = 1:size(files, 1)
    %Expected maximum number of windows
    samples = 1000;
    value = num2cell(zeros( samples, 1));
    
    BBox_final = struct('x', value, 'y', value, 'w',value, 'h', value);
    idx_BB_final = 1;
    
    imagename = char(files(j).name);
    sprintf(imagename)
    Mask = imread(strcat(params.directory_read_mask, imagename,'_morf.png'));
%     Mask = Mask/max(Mask(:));
    %We will compute different type of windows for each type of signal,
    %because they have different form factor. t correponds to the type of
    %sign: 1-triangle, 2-circle and 3-square
    [row, col] = size(Mask);
    image = Mask;
    for k = 1:row
        for l = 1:col
                ii(k,l) = cumsum(cumsum(double(image(k,l))),2);
        end
    end

    
    for t = 1:3
        width_sizes = round(Characteristics(t).min_w):step_window:round(Characteristics(t).max_w);
        if width_sizes(end) < Characteristics(t).max_w
            width_sizes = [width_sizes round(Characteristics(t).max_w)];
        end
        
        height_sizes = round(Characteristics(t).mean_form_factor*width_sizes);
        for n = size(width_sizes, 1);
            %For each size of window, find signs
            %BBox save the windos find with a certain window and a certain
            %threshold and from factor
            BBox = struct('x', value, 'y', value, 'w',value, 'h', value);
            idx_BB = 1;
            window_width = width_sizes(n);
            window_height = height_sizes(n);
            windowArea = window_width * window_height;
            
            
%             ii_pad = padarray(ii,[window_height-1 window_width-1],'replicate','post');
%             dim = size(ii_pad);
            
            dim = size(Mask);
            
            %Movimiento por columnas
            for y = 1:step_window:(dim(1) - window_height)
                %Movimiento por filas
                for x = 1:step_window:(dim(2) - window_width)
                    
                    bbSum = ii(y + (window_height-1),x + (window_width-1))...
                    - ii(y, x + (window_width-1)) - ii(y + (window_height-1),x)...
                    + ii(y,x);
                    
%                     windowArea = window_height*window_width;
                    filling = bbSum/(windowArea);
                    
%                     Window = Mask(y:window_width + y, x:window_height + x);
%                     validate = Validate_window(Window, Characteristics(t));
                    
%                     if validate
                    if filling > Characteristics(t).min_fill_ratio && filling < Characteristics(t).max_fill_ratio 
                        
                        BBox(idx_BB).y = y;
                        BBox(idx_BB).x = x;
                        BBox(idx_BB).w = window_width;
                        BBox(idx_BB).h = window_height;
                        idx_BB = idx_BB + 1;
                        
                    end
                end
            end
            BBox(idx_BB:length(BBox)) = [];
                       
        end
        %With a concrete size we have find many windows,we eliminate
        %overlaps
        BBox = Clear_overlap(BBox, Mask);
        BBox_final(idx_BB_final + (1:length(BBox))- 1) = BBox;
        %This variable saves all the windows of different sizes
        idx_BB_final = idx_BB_final + length(BBox);
    
    end
    
     windowCandidates = Clear_overlap(BBox_final, Mask);

    save(strcat(params.directory_write_results, '/', imagename, '_mask.mat'), 'windowCandidates');
end
empty = [];
end

