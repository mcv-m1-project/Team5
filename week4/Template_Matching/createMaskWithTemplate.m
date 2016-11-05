function mask = createMaskWithTemplate(wc,template,mask_size)
    mask=zeros(mask_size);
    
    for i=1:length(wc)
        rt=double(logical(imresize(template,[wc(i).h wc(i).w])));
        mask(round(wc(i).y):round(wc(i).y+wc(i).h-1),round(wc(i).x):round(wc(i).x+wc(i).w-1))=rt(:,:);
    end
end