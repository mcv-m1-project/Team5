function meanModel = ComputeMeanGrayImageForSignGroup(SC,images_dir)
%Given a set of images, computes the mean grayscale image

anns=[SC{:,6}];
templatej=round(mean([anns.w]));
templatei=round(mean([anns.h])); %Size mean of this group of signs
meanModel=zeros([templatei,templatej]);

for i=1:length(SC)
    im=double(rgb2gray(imread(strcat(images_dir,filesep,SC{i,1},'.jpg'))));
    mask=imread(strcat(images_dir, '/mask/mask.', SC{i,1}, '.png'))>0;
    im(~mask)=0;
    
    ann=SC{i,6};%Sign coordinates
    sign=im(round(ann.y):round(ann.y+ann.h),round(ann.x):round(ann.x+ann.w)); 
    sign=imresize(sign,size(meanModel));
    
    meanModel=meanModel+sign;
end

meanModel=uint8(meanModel/length(SC));

end