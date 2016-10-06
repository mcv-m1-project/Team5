function aplicarUmbral
    archivos = dir('*.jpg'); %load the images

    for k = 1:length(archivos)
        
        %Otsu's method
        image = imread(archivos(k).name);
        imagename = archivos(k).name(1:end-4);
        redThresh = multithresh(image(:,:,1),2);
        greenThresh = multithresh(image(:,:,2),2);
        blueThresh = multithresh(image(:,:,3),2);
        red = image(:,:,1) > redThresh(1) & image(:,:,2) < greenThresh(1) & image(:,:,3) < blueThresh(1);
        blue = image(:,:,1) < redThresh(1) & image(:,:,2) < greenThresh(1) & image(:,:,3) > blueThresh(1);
%       subplot(121),imshow(red);
%       subplot(122), imshow(blue);
        umbral = red | blue;
        imwrite(umbral,strcat('Masks/',imagename,'_mask.jpg'));
 
    end
end
