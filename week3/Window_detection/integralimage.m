
image = imread('00.000948_morf.jpg');
% image = imread(strcat(path_images_read, imagename,'_morf.jpg'));
% figure,imshow(image,[])
[row,col] = size(image);
step_window = 1;
ii = zeros(row,col);
windowHeight = 3;
windowWidth = 5;
windowArea = windowHeight*windowWidth;

value = num2cell(zeros( 50, 1));
BBox = struct('x', value, 'y', value, 'w',value, 'h', value);
idx_BB = 1;

validation_crit = Validation_criteria( SC_train );

for i = 1:row
    for j = 1:col
        ii(i,j) = cumsum(cumsum(double(image(i,j))),2);
    end
end
% figure,imshow(ii,[])

ii_pad = padarray(ii,[windowHeight-1 windowWidth-1],'replicate','post');
[row2,col2] = size(ii_pad);

for k = 1:step_window:(row2 - (windowHeight-1))
    for l = 1:step_window:(col2 - (windowWidth-1)) 
        
        bbSum = ii_pad(k + (windowHeight-1),l + (windowWidth-1))...
            - ii_pad(k, l + (windowWidth-1)) - ii_pad(k + (windowHeight-1),l)...
            + ii_pad(k,l);
        
        filling = bbSum/(windowArea);
        window = image(k:k + (windowHeight - 1), l:l + (windowWidth - 1));

        if filling > validation_crit(1, 1) && filling < validation_crit(1, 2) ||... % Triangles
           filling > validation_crit(2, 1) && filling < validation_crit(2, 2) ||... % Circles
           filling > validation_crit(3, 1) && filling < validation_crit(3, 2)       % Squares
       
                BBox(idx_BB).x = j;
                BBox(idx_BB).y = k;
                BBox(idx_BB).w = windowWidth;
                BBox(idx_BB).h = windowHeight;
                idx_BB = idx_BB + 1;
        end
    end
end

% figure,imshow(iibb,[])