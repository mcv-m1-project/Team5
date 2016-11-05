function [windowCandidates,mask]=TemplateMatchingCorrelationGlobal(im,templates,corr_threshold)
    windowCandidates = [];
    mask=zeros(size(im));
    for i=1:length(templates)
        correlation = normxcorr2(templates{i},im);
        
        if max(max(correlation))>corr_threshold
            %TODO: threshold (several wc), not only the max corr
            [ypeak, xpeak] = find(correlation==max(correlation(:)));

            yoffSet = ypeak-size(templates{i},1);
            xoffSet = xpeak-size(templates{i},2);
            xoffSet(xoffSet<0)=0;
            yoffSet(yoffSet<0)=0;
            xoffSet(xoffSet+size(templates{i},2)>size(im,2))=size(im,2)-size(templates{i},2);
            yoffSet(yoffSet+size(templates{i},1)>size(im,1))=size(im,1)-size(templates{i},1);
            new_WC = struct('x',xoffSet+1,'y',yoffSet+1,'w',size(templates{i},2),'h',size(templates{i},1));

            windowCandidates=[windowCandidates;new_WC];
            
            %Create mask with template shape
            mask=mask+createMaskWithTemplate(new_WC,templates{i},size(mask));
        end
    end
end