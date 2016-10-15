
% path_images = '/Users/lidiatalavera/Desktop/señales/';
% colorSpace=2;
% Mask(path_images,colorSpace)
% function Mask2(path_images,path_GT,colorSpace)
function theTime = Mask4(path_images, colorSpace)


mkdir([path_images 'Masks'])
Imgs = dir([path_images '/*.jpg']);
%Imgs_GT = dir([path_GT '/*.png']);
ext='.jpg';
theTime = zeros(362,1);
% colorSpace=2;

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
            labImage = rgb2lab(rgbImage);
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

end