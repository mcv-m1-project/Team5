function time = task3block2(path_masks, Masks, path_images_write)
%Morfology
% This function applies morfological operators in order to reduce noise
% of the masks generated with color segmentation

theTime = zeros(size(Masks, 1),1);

for k = 1:length(Masks)
    tic
    
    %The masks are loaded
    mask = imread(strcat(path_masks, Masks(k).name, '_mask.png'));
    imagename = Masks(k).name;
    
    %First, Structural elements are created
    
    se = strel('diamond', 5);
    se2 = strel('line', 10, 0);
    se3 = strel('line', 10, 90);
    % se4 = strel('square',3);
    
    
    %Now, holes are filled so we get the whole sign
%     maskWholes = imfill(mask);
    maskWholes = imfill(mask, 'holes');
    % Afterwards, Noise is intended to be removed. Opening operation is used
    % since small noise appears on the image.
    
    maskOp = imopen(maskWholes, se);    
    
    %At this point, It is tried to removed every vertical line which is not likely
    %to be a sign. the goal is to get rid of the stick whick holds the sign
    
    maskOpL = imopen (maskOp, se2);    
    
    maskOpL = imopen (maskOpL, se3);
    
    imwrite(maskOpL, strcat(path_images_write, imagename,'_morf.png'));
    theTime(k) = toc;
end
time = mean(theTime);
end