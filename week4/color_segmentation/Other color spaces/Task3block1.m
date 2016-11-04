function time = Task3block1(path_images, Imgs, path_images_write, colorSpace)
% Task 3. Task3block1 is a function that perfoms a segmentation of the red
% and blue colors over an input RGB image. The function has the next
% three input parameters (IP) and one output parameter (OP).
%
% path_images:(IP) Is the path where we can find all the dataset.
% Imgs:(IP) List of images that have been chosen as training set (Task 2)
% on which segmentation will be performed.
% colorSpace:(IP) number that represents the method applied to implement
% the segmentation.
%                                  ------Method------
%       colorSpace 1 -> RGB with manual selection of the thresholds.
%       colorSpace 2 -> RGB using Otsu's segmentation method.
%       colorSpace 3 -> Segmentation on HSV color space.
%       colorSpace 4 -> Segmentation on Lab color space.
%       colorSpace 5 -> Segmentation on YUV color space.
%       colorSpace 6 -> Combination of HSV and RGB color spaces.
%       colorSpace 7 -> Histogram Back Projection on HSV color space.
%
% time:(OP) number that represents the average of time that is needed for
% execute the segmentation for a specific method.


ext='.jpg';
theTime = zeros(size(Imgs, 1),1);


switch colorSpace
    case 1
        if ~exist(strcat(path_images_write,'/RGBManual') , 'dir')
            mkdir( strcat(path_images_write,'/RGBManual'));
        end

        for numImagen = 1:length(Imgs)
            tic
            
            rgbImage = imread(strcat(path_images, '/', strcat(Imgs(numImagen).name), '.jpg'));
            Imgswithoutext = strrep(Imgs(numImagen).name,ext,'');
            
            
%             redMask = rgbImage(:,:,1) > 50 & rgbImage(:,:,2) < 40 &...
%             redMask = rgbImage(:,:,1) > 40 & rgbImage(:,:,2) < 40 &...
%             rgbImage(:,:,3) < 40;
            % Blue segmentation
            

            
            
            % Red segmentation
            %Old
%             redMask = rgbImage(:,:,1) > 50 & rgbImage(:,:,2) < 40 &...
            %New
%             redMask = rgbImage(:,:,1) > 40 & rgbImage(:,:,2) < 40 &...

            redMask = rgbImage(:,:,1) > 40 & rgbImage(:,:,2) < 40 &...
                rgbImage(:,:,3) < 40;
            % Blue segmentation
            blueMask = rgbImage(:,:,1) < 50 & rgbImage(:,:,2) < 60 &...
                rgbImage(:,:,3) > 40;
            % Old
%             rgbImage(:,:,3) > 60;
            %New
%             rgbImage(:,:,3) > 40;
            % Combination of the red and blue segmentation -> binary image
            Mask = redMask | blueMask;
            
            imwrite(Mask,[path_images_write '/RGBManual/' Imgswithoutext...
                '_mask.png' ]);
            
            theTime(numImagen) = toc;
        end
        
    case 2
        if ~exist(strcat(path_images_write, '/OtsuRGB') , 'dir')
            mkdir( strcat(path_images_write, '/OtsuRGB'));
        end

        for numImagen = 1:length(Imgs)
            tic
            close all;	% Close all figure windows
            rgbImage = imread(strcat(path_images, '/', strcat(Imgs(numImagen).name), '.jpg'));
            
            Imgswithoutext = strrep(Imgs(numImagen).name,ext,'');
            
            redThresh = multithresh(rgbImage(:,:,1),2);
            greenThresh = multithresh(rgbImage(:,:,2),2);
            blueThresh = multithresh(rgbImage(:,:,3),2);
            
            redMask = rgbImage(:,:,1) > redThresh(1) &...
                rgbImage(:,:,2) < greenThresh(1) &...
                rgbImage(:,:,3) < blueThresh(1);
            blueMask = rgbImage(:,:,1) < redThresh(1) &...
                rgbImage(:,:,2) < greenThresh(1) &...
                rgbImage(:,:,3) > blueThresh(1);
            
            Mask = redMask | blueMask;
            
            imwrite(Mask,[path_images_write '/OtsuRGB/' Imgswithoutext...
                '_mask.png' ]);
            theTime(numImagen) = toc;
            
        end
        
    case 3
        if ~exist(strcat(path_images_write, '/HSV') , 'dir')
            mkdir( strcat(path_images_write, '/HSV'));
        end
        
        for numImagen = 1:length(Imgs)
            tic
            rgbImage = imread(strcat(path_images, '/', strcat(Imgs(numImagen).name), '.jpg'));
            
            Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            
            % Convert RGB image to HSV space
            
            hsvImage = rgb2hsv(rgbImage);
            hImage = round(hsvImage(:,:,1)*360);% multiplied by 360 because hue is defined as and angle [0,2pi]
            sImage = hsvImage(:,:,2);
            vImage = hsvImage(:,:,3);
            
            % A "threshold" of the hsv components of pixels must be an interval
            hredInterval = [340 30]; % Range of hue values considered 'red'
            hblueInterval = [190 240]; % Range of hue values considered 'blue'
            %Old
%             hredInterval = [350 20]; % Range of hue values considered 'red'
%             hblueInterval = [200 230]; % Range of hue values considered 'blue'
            %New
%             hredInterval = [340 30]; % Range of hue values considered 'red'
%             hblueInterval = [190 240]; % Range of hue values considered 'blue'

            sInterval = [0.5 1]; % Minimum saturation value to exclude noise
            vInterval = [0.1 1];
            
            redMask = (hImage >=hredInterval(1) | hImage <= hredInterval(2)) &...
                sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
            
            blueMask = (hImage >= hblueInterval(1) & hImage <= hblueInterval(2)) &...
                sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
            
            
            Mask = redMask | blueMask;
            imwrite(Mask,[path_images_write '/HSV/' Imgswithoutext...
                '_mask.png' ]);
            theTime(numImagen) = toc;
            
        end
    case 4
        if ~exist(strcat(path_images_write, '/Lab') , 'dir')
            mkdir( strcat(path_images_write, '/Lab'));
        end

        for numImagen = 1:length(Imgs)
            tic
            rgbImage = imread(strcat(path_images, '/', strcat(Imgs(numImagen).name), '.jpg'));
            Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            labImage = zeros(size(rgbImage));
            [labImage(:, :, 1), labImage(:, :, 2), labImage(:, :, 3)] = RGB2Lab_own(rgbImage(:, :, 1), rgbImage(:, :, 2), rgbImage(:, :, 3));
            %             labImage = rgb2lab(rgbImage);
            redMask = labImage(:,:,2)==1 & labImage(:,:,3)==1;
            blueMask = labImage(:,:,2)==0 & labImage(:,:,3)==0;
            
            Mask = redMask | blueMask;
            imwrite(Mask,[path_images_write '/Lab/' Imgswithoutext...
                '_mask.png' ]);
            theTime(numImagen) = toc;
        end
        
    case 5
        if ~exist(strcat(path_images_write, '/YUV') , 'dir')
            mkdir( strcat(path_images_write, '/YUV'));
        end

        for numImagen = 1:length(Imgs)
            tic
            rgbImage = imread(strcat(path_images, '/', strcat(Imgs(numImagen).name), '.jpg'));

            yuvImage = rgb2yuv(rgbImage);
            Imgswithoutext = strrep(Imgs(numImagen).name,ext,'');
            
            redMask = yuvImage(:,:,2) > 110 & yuvImage(:,:,2) < 130 & ...
                yuvImage(:,:,3) > 135 & yuvImage(:,:,3) < 165;
            
            blueMask = yuvImage(:,:,2) > 140 & yuvImage(:,:,2) < 170 & ...
                yuvImage(:,:,3) > 100 & yuvImage(:,:,3) < 120;
            
            Mask = redMask | blueMask;
            imwrite(Mask,[path_images_write '/YUV/' Imgswithoutext...
                '_mask.png' ]);
            
            theTime(numImagen) = toc;
        end
    case 6
        if ~exist(strcat(path_images_write, '/HSV&RGB') , 'dir')
            mkdir( strcat(path_images_write, '/HSV&RGB'));
        end

        for numImagen=1:length(Imgs)
            tic
            rgbImage = imread(strcat(path_images, '/', strcat(Imgs(numImagen).name), '.jpg'));
            
            % Convert RGB image to HSV space
            
            hsvImage = rgb2hsv(rgbImage);
            
            hImage = round(hsvImage(:,:,1)*360);% multiplied by 360 because hue is defined as and angle [0,2pi]
            sImage = hsvImage(:,:,2);
            vImage = hsvImage(:,:,3);
            
            % A "threshold" of the hsv components of pixels must be an interval
            hredInterval = [340 30]; % Range of hue values considered 'red'
            hblueInterval = [190 240]; % Range of hue values considered 'blue'
            
            %Old
%             hredInterval = [350 20]; % Range of hue values considered 'red'
%             hblueInterval = [200 230]; % Range of hue values considered 'blue'
            %New
%             hredInterval = [340 30]; % Range of hue values considered 'red'
%             hblueInterval = [190 240]; % Range of hue values considered 'blue'

            
            sInterval = [0.5 1]; % Minimum saturation value to exclude noise
            vInterval = [0.1 1];
            
            redMask = (hImage >= hredInterval(1) | hImage <= hredInterval(2)) & ...
                sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
            
            blueMask = (hImage >= hblueInterval(1) & hImage <= hblueInterval(2)) &...
                sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
            
            
            Mask1 = redMask | blueMask;
            
            rgbImage = imread(strcat(path_images, '/', strcat(Imgs(numImagen).name), '.jpg'));
            
            Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            
            redThresh = multithresh(rgbImage(:,:,1),2);
            greenThresh = multithresh(rgbImage(:,:,2),2);
            blueThresh = multithresh(rgbImage(:,:,3),2);
            
            redMask2 = rgbImage(:,:,1) > redThresh(1) &...
                rgbImage(:,:,2) < greenThresh(1) &...
                rgbImage(:,:,3) < blueThresh(1);
            blueMask2 = rgbImage(:,:,1) < redThresh(1) &...
                rgbImage(:,:,2) < greenThresh(1) &...
                rgbImage(:,:,3) > blueThresh(1);
            
            Mask2 = redMask2 | blueMask2;
            Mask = Mask1 & Mask2;
            
            imwrite(Mask,[path_images_write '/HSV&RGB/' Imgswithoutext...
                '_mask.png' ]);
            theTime(numImagen) = toc;
        end
    case 7
        threshold = 0.00006;%Between 0 and 1
        circle_radius = 3;%Radius of the circle to convolve
        theTime = histogramBackProjectionSegmentation2(threshold, circle_radius, Imgs, path_images, path_images_write);
        
        
end
time = mean(theTime);
end