function mask = createMaskWithTemplate(wc,template,mask_size)
    mask=zeros(mask_size);
    rt=double(logical(imresize(template,[wc.h wc.w])));
    mask(round(wc.y):round(wc.y+wc.h-1),round(wc.x):round(wc.x+wc.w-1))=rt(:,:);
end