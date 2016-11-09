function [] = Integral_Image( path_images_read, directory_write, pixel_method, SC_train )

step_window = 1;
windowHeight = 3;
windowWidth = 5;
windowArea = windowHeight*windowWidth;

% validation_crit = Validation_criteria( SC_train );
params = trainSignCharacteristicsCCL(SC_train);

    switch pixel_method
        case 1
            path_images_read = strcat(path_images_read, '/week_02/train_result/RGBManual/');
        case 2
            path_images_read = strcat(path_images_read, '/week_02/train_result/HSV/');
        case 3
            path_images_read = strcat(path_images_read, '/week_02/train_result/YUV/');
        case 4
            path_images_read = strcat(path_images_read, '/week_02/train_result/HSV&RGB/');
        case 5
            path_images_read = strcat(path_images_read, '/week_02/train_result/histBP/');
    end

    for m = 1:size(SC_train, 1)

        value = num2cell(zeros( 50, 1));
        BBox = struct('x', value, 'y', value, 'w',value, 'h', value);
        idx_BB = 1;

        imagename = char(SC_train(m, 1));
        image = imread(strcat(path_images_read, imagename,'_morf.jpg'));
        [row,col] = size(image);
        ii = zeros(row,col);

        for i = 1:row
            for j = 1:col
                ii(i,j) = cumsum(cumsum(double(image(i,j))),2);
            end
        end

        ii_pad = padarray(ii,[windowHeight-1 windowWidth-1],'replicate','post');
        [row2,col2] = size(ii_pad);

        for k = 1:step_window:(row2 - (windowHeight-1))
            for l = 1:step_window:(col2 - (windowWidth-1)) 

                bbSum = ii_pad(k + (windowHeight-1),l + (windowWidth-1))...
                    - ii_pad(k, l + (windowWidth-1)) - ii_pad(k + (windowHeight-1),l)...
                    + ii_pad(k,l);

                filling = bbSum/(windowArea);
%                 window = image(k:k + (windowHeight - 1), l:l + (windowWidth - 1));

%                 if filling > validation_crit(1, 1) && filling < validation_crit(1, 2) ||... % Triangles
%                    filling > validation_crit(2, 1) && filling < validation_crit(2, 2) ||... % Circles
%                    filling > validation_crit(3, 1) && filling < validation_crit(3, 2)       % Squares
                if filling > params.minfr && filling < params.maxfr 
                        BBox(idx_BB).x = k;
                        BBox(idx_BB).y = l;
                        BBox(idx_BB).w = windowWidth;
                        BBox(idx_BB).h = windowHeight;
                        idx_BB = idx_BB + 1;
                end
            end
        end
        save(strcat(directory_write, '/IntegralImage/', imagename, '_boxes'), 'BBox');
    end
end