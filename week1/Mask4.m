function time = Mask4(path_images, Imgs, colorSpace)
mkdir([path_images 'Masks'])
Imgs = dir([path_images '/*.jpg']);

ext='.jpg';
theTime = zeros(size(Imgs, 1),1); 


switch colorSpace
    case 1
        mkdir([path_images 'Masks/OtsuRGB'])
        for numImagen = 1:length(Imgs)
            tic
            close all;	% Close all figure windows
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            %GT = imread(strcat(path_GT,Imgs_GT(numImagen).name));
            
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
            
            %figure, imshow(redMask)
            %figure, imshow(blueMask)
            Mask = redMask | blueMask;
            %figure, imshow(Mask)
            imwrite(Mask,[path_images 'Masks/OtsuRGB/' Imgswithoutext...
                '_mask.jpg' ]);
            theTime(numImagen) = toc;
            
        end
        
    case 2
        mkdir([path_images 'Masks/HSV'])
        for numImagen=1:length(Imgs)
       tic
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            
            Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            %imshow(rgbImage)
            
            % Convert RGB image to HSV space
            
            hsvImage = rgb2hsv(rgbImage);
            %figure, imshow(hsvImage)
            hImage = round(hsvImage(:,:,1)*360);% multiplied by 360 because hue is defined as and angle [0,2pi]
            sImage = hsvImage(:,:,2);
            vImage = hsvImage(:,:,3);
            
            % A "threshold" of the hsv components of pixels must be an interval
            hredInterval = [350 20]; % Range of hue values considered 'red'
            hblueInterval = [200 230]; % Range of hue values considered 'blue'
            
            sInterval = [0.5 1]; % Minimum saturation value to exclude noise
            vInterval = [0.1 1];
            
            redMask = (hImage >=hredInterval(1) | hImage <= hredInterval(2)) &... 
                  sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);

            blueMask = (hImage >= hblueInterval(1) & hImage <= hblueInterval(2)) &...
                  sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
     
            
            Mask = redMask | blueMask;
            %figure,imshow(Mask)
            imwrite(Mask,[path_images 'Masks/HSV/' Imgswithoutext...
                '_mask.jpg' ]);
            theTime(numImagen) = toc;
  
        end
    case 3
        mkdir([path_images 'Masks/Lab'])
        for numImagen=1:length(Imgs)
            tic
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            labImage = zeros(size(rgbImage));
            [labImage(:, :, 1), labImage(:, :, 2), labImage(:, :, 3)] = RGB2Lab_own(rgbImage(:, :, 1), rgbImage(:, :, 2), rgbImage(:, :, 3));
%             labImage = rgb2lab(rgbImage);
            redMask = labImage(:,:,2)==1 & labImage(:,:,3)==1;
            %figure,imshow(redMask)
            blueMask = labImage(:,:,2)==0 & labImage(:,:,3)==0;
            %figure,imshow(blueMask)
            
            Mask = redMask | blueMask;
            imwrite(Mask,[path_images 'Masks/Lab/' Imgswithoutext...
                '_mask.jpg' ]);
            theTime(numImagen) = toc;
        end
    case 4
        mkdir([path_images 'Masks/HSV&RGB'])
        for numImagen=1:length(Imgs)
            tic
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            
            % Convert RGB image to HSV space
            
            hsvImage = rgb2hsv(rgbImage);
            %figure, imshow(hsvImage)
            hImage = round(hsvImage(:,:,1)*360);% multiplied by 360 because hue is defined as and angle [0,2pi]
            sImage = hsvImage(:,:,2);
            vImage = hsvImage(:,:,3);
            
            % A "threshold" of the hsv components of pixels must be an interval
            hredInterval = [350 20]; % Range of hue values considered 'red'
            hblueInterval = [200 230]; % Range of hue values considered 'blue'
            
            sInterval = [0.5 1]; % Minimum saturation value to exclude noise
            vInterval = [0.1 1];
            
            redMask = (hImage >= hredInterval(1) | hImage <= hredInterval(2)) & ...
                sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
            %figure,imshow(redMask)
            blueMask = (hImage >= hblueInterval(1) & hImage <= hblueInterval(2)) &...
                sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
            %figure,imshow(blueMask)
            
            Mask1 = redMask | blueMask;
            
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            %imshow(rgbImage)
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
            
            %figure, imshow(redMask)
            %figure, imshow(blueMask)
            Mask2 = redMask2 | blueMask2;
            Mask = Mask1 & Mask2;
            %figure,imshow(Mask)
            imwrite(Mask,[path_images 'Masks/HSV&RGB/' Imgswithoutext...
                '_mask.jpg' ]);
            theTime(numImagen) = toc;
        end
    case 5
        mkdir([path_images 'Masks/RGBManual'])
        for numImagen=1:length(Imgs)
        tic
        rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            %GT = imread(strcat(path_GT,Imgs_GT(numImagen).name));
            
        Imgswithoutext = strrep(Imgs(numImagen).name,ext,'');
            
                redMask = rgbImage(:,:,1) > 50 &...
                rgbImage(:,:,2) < 40 &...
                rgbImage(:,:,3) < 40;
            
                blueMask = rgbImage(:,:,1) < 50 &...
                rgbImage(:,:,2) < 60 &...
                rgbImage(:,:,3) > 60;
            
            Mask = redMask | blueMask;
            imwrite(Mask,[path_images 'Masks/RGBManual/' Imgswithoutext...
                '_mask.jpg' ]);
   
         theTime(numImagen) = toc;
        end

    case 6
        mkdir([path_images 'Masks/YUV'])
        for numImagen=1:length(Imgs)
        tic
        rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            %GT = imread(strcat(path_GT,Imgs_GT(numImagen).name));
        yuvImage = rgb2yuv(rgbImage);
        Imgswithoutext = strrep(Imgs(numImagen).name,ext,'');
            
                redMask = yuvImage(:,:,2) > 110 & yuvImage(:,:,2) < 130 & ...
                yuvImage(:,:,3) > 135 & yuvImage(:,:,3) < 165;
            
                blueMask = yuvImage(:,:,2) > 140 & yuvImage(:,:,2) < 170 & ...
                yuvImage(:,:,3) > 100 & yuvImage(:,:,3) < 120;
            
            Mask = redMask | blueMask;
            imwrite(Mask,[path_images 'Masks/YUV/' Imgswithoutext...
                '_mask.jpg' ]);
   
         theTime(numImagen) = toc;
        end
end
time = mean(theTime);
end