function theTime = histogramBackProjectionSegmentation(prob_threshold,image_names,directory_read_train,path_images_write)
    theTime = zeros(length(image_names),1);

    %Load train histograms
    load(strcat(path_images_write, '/..', '/Histogram_2D_group3'));
    load(strcat(path_images_write, '/..', '/Histogram_2D_group2'));
    load(strcat(path_images_write, '/..', '/Histogram_2D_group1'));

    nbins=[size(H2D_group1,1) size(H2D_group1,2)];
    
    %Writting directory
    if ~exist(strcat(path_images_write,'/histBP'),'dir')
        mkdir(strcat(path_images_write,'/histBP'));
    end

    %Test images
    for i=1:length(image_names)
        tic;
        
        %Load and convert RGB image to HSV space
        hsvImage = rgb2hsv(imread(strcat(directory_read_train, filesep, image_names(i).name, '.jpg')));

        %Arrays of probabilities for each group of signs
        P1=zeros(size(hsvImage(:,:,1)));
        P2=zeros(size(hsvImage(:,:,1)));
        P3=zeros(size(hsvImage(:,:,1)));        
        
        %For each pixel of the test image
        for j=1:size(hsvImage(:,:,1),1)
            for k=1:size(hsvImage(:,:,1),2)
                hist_Xidx=round(hsvImage(j,k,1)*(nbins(1)-1))+1;
                hist_Yidx=round(hsvImage(j,k,2)*(nbins(2)-1))+1;
                P1(j,k)=H2D_group1(hist_Xidx,hist_Yidx);
                P2(j,k)=H2D_group2(hist_Xidx,hist_Yidx);
                P3(j,k)=H2D_group3(hist_Xidx,hist_Yidx);
            end
        end

        maskG1=P1>prob_threshold*max(max(P1));
        maskG2=P2>prob_threshold*max(max(P2));
        maskG3=P3>prob_threshold*max(max(P3));

        imwrite(maskG1|maskG2|maskG3,strcat(path_images_write,'/histBP/',image_names(i).name,'_mask.jpg'));
        
        theTime(i) = toc;
    end
end