function H2D=groupHistogramHS(SC,nbins,images_dir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Computes the 2D histogram using the Hue and Saturation of the HSV 
%   colorspace for a group of signs.
%
%   'SC' Sign characteristics matrix for the given group of signs
%   'nbins' Number of bins of the 2D histogram
%   'images_dir' Path of the directory where the images are
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    H2D=zeros(nbins);
    for i=1:size(SC,1)
        ann=SC{i,6};%Sign coordinates
        srow=round(ann.y):round(ann.y+ann.h);%Sign rows
        scol=round(ann.x):round(ann.x+ann.w);%Sign columns
        
        %Load and convert RGB image to HSV space
        rgbImage = imread(strcat(images_dir, SC{i,1}, '.jpg'));
        %Use only the part of the image that corresponds to the sign
        hsvImage = rgb2hsv(rgbImage(srow,scol,:));

        %Load mask
        mask=imread(strcat(images_dir, 'mask/mask.', SC{i,1}, '.png'))>0;
        mask=mask(srow,scol);   
        
        h = hsvImage(:,:,1);
        s = hsvImage(:,:,2);

        %2D histogram
        H2D=H2D+hist3([h(mask),s(mask)],nbins);
    end
end