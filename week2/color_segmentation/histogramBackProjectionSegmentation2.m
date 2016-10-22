function theTime = histogramBackProjectionSegmentation2(threshold,r,image_names,directory_read_train,path_images_write)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Implementation of the object location algorithm proposed by Swain and 
%   Ballard in "Indexing via Color Histograms"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

    %circle
    [x,y]=meshgrid(-r:r,-r:r);
    circlem=double(((x.^2+y.^2)<=r^2));
    
    %Test images
    for i=1:length(image_names)
        tic;
        
        %Load and convert RGB image to HSV space
        hsvImage = rgb2hsv(imread(strcat(directory_read_train, filesep, image_names(i).name, '.jpg')));
        h = hsvImage(:,:,1);
        s = hsvImage(:,:,2);
        
        %2D histogram of the test image
        I=hist3([h(:),s(:)],nbins);
        
        %Histogram ratio R=M/I
        R1=H2D_group1./I;
        R2=H2D_group2./I;
        R3=H2D_group3./I;
        
        %Backprojected images
        B1=zeros(size(h));
        B2=zeros(size(h));
        B3=zeros(size(h));
        
        %For each pixel of the test image
        for j=1:size(h,1)
            for k=1:size(h,2)
                hist_Xidx=round(h(j,k)*(nbins(1)-1))+1;
                hist_Yidx=round(s(j,k)*(nbins(2)-1))+1;
                
                B1(j,k)=R1(hist_Xidx,hist_Yidx);
                B2(j,k)=R2(hist_Xidx,hist_Yidx);
                B3(j,k)=R3(hist_Xidx,hist_Yidx);
            end
        end
        
        B1=min(B1,1);
        B1 = conv2(B1,circlem);
        B1=B1/max(max(B1));
        B1=B1>threshold;%mask group1
        
        B2=min(B2,1);
        B2 = conv2(B2,circlem);
        B2=B2/max(max(B2));
        B2=B2>threshold;%mask group2
        
        B3=min(B3,1);
        B3 = conv2(B3,circlem);
        B3=B3/max(max(B3));
        B3=B3>threshold;%mask group3
        
        imwrite(B1|B2|B3,strcat(path_images_write,'/histBP/',image_names(i).name,'_mask.jpg'));
                
        theTime(i) = toc;
    end
end