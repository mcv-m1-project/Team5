
% path_images = '/Users/lidiatalavera/Desktop/señales/';
% colorSpace=2;
% Mask(path_images,colorSpace)
function Mask(path_images,colorSpace)

mkdir([path_images 'Masks'])
Imgs = dir([path_images '/*.jpg']);
ext='.jpg';

% colorSpace=2;

switch colorSpace
    case 1
        mkdir([path_images 'Masks/OtsuRGB'])
        for numImagen=1:length(Imgs)
            close all;	% Close all figure windows
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            %imshow(rgbImage)
            Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            
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
        end
        
    case 2
        mkdir([path_images 'Masks/HSV'])
         for numImagen=1:length(Imgs)
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
            hredInterval = [320 60]; % Range of hue values considered 'red'
            hblueInterval = [180 300]; % Range of hue values considered 'blue'

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

            Mask = redMask | blueMask;
            %figure,imshow(Mask)
            imwrite(Mask,[path_images 'Masks/HSV/' Imgswithoutext...
                '_mask.jpg' ]);   
         end
         
    case 3
         mkdir([path_images 'Masks/Lab'])
         for numImagen=1:length(Imgs)
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
             Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            %imshow(rgbImage)
%             rgbImage=imread('01.002070.jpg');
            % Convert RGB image to Lab space
            LabImage = rgb2lab(rgbImage);
            
            %figure, imshow(hsvImage)
            LImage = LabImage(:,:,1);
            aImage = LabImage(:,:,2);
            bImage = LabImage(:,:,3);
            
            ax=graythresh(aImage);
            BW = im2bw(aImage,ax);
            imshow(BW)
            bx=graythresh(bImage);
            BW2 = im2bw(bImage,bx);
            figure,imshow(BW2)
            Mask=BW&BW2;
            
%             LredInterval=[20 55];
%             aredInterval=[50 90];
%             bredInterval=[35 60];
%             
%             LblueInterval=[10 60];
%             ablueInterval=[-30 15];
%             bblueInterval=[-100 -46];           
%             
%             redMask = (aImage==68 & bImage==48) | (LImage>=35 & LImage<=55);
%             
%             redMask = (aImage >= aredInterval(1) | aImage <= aredInterval(2)) & ...
%             (bImage >= bredInterval(1) | bImage <= bredInterval(2)) &  ...
%             (LImage >= LredInterval(1) & LImage <= LredInterval(2));
%             figure,imshow(redMask)
%             
%             blueMask = (aImage >= ablueInterval(1) | aImage <= ablueInterval(2)) &...
%             (bImage >= bblueInterval(1) | aImage <= bblueInterval(2)) & ...
%             (LImage >= LblueInterval(1) & LImage <= LblueInterval(2));
%             figure,imshow(blueMask)
% 
%             Mask = redMask | blueMask;
            %figure,imshow(Mask)
            imwrite(Mask,[path_images 'Masks/Lab/' Imgswithoutext...
                '_mask.jpg' ]);   
         end
end
end