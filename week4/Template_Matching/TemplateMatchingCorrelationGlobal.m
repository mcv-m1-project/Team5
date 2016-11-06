function [windowCandidates,mask]=TemplateMatchingCorrelationGlobal(im,templates,corr_threshold)
%Find the peaks of correlation between the image and the templates, that
%are higher than the threshold. This function  returns the window 
%candidates and the generated mask.
    windowCandidates = [];
    mask=zeros(size(im));
    for i=1:length(templates)
        correlation = normxcorr2(templates{i},im);
        
        if max(max(correlation))>corr_threshold
            [ypeak, xpeak] = find(correlation>corr_threshold);

            yoffSet = ypeak-size(templates{i},1);
            xoffSet = xpeak-size(templates{i},2);
            xoffSet(xoffSet<0)=0;
            yoffSet(yoffSet<0)=0;
            xoffSet(xoffSet+size(templates{i},2)>size(im,2))=size(im,2)-size(templates{i},2);
            yoffSet(yoffSet+size(templates{i},1)>size(im,1))=size(im,1)-size(templates{i},1);
            
            new_WC = struct('x',num2cell(xoffSet+1),'y',num2cell(yoffSet+1),'w',{size(templates{i},2)},'h',{size(templates{i},1)});
            
            %Remove repeated windowCandidates
            [~,idxs,~] = unique(cell2mat(struct2cell(new_WC)'),'rows');
            new_WC=new_WC(idxs);
            
            windowCandidates=[windowCandidates;new_WC];
            
            %Create mask with template shape
            mask=mask+createMaskWithTemplate(new_WC,templates{i},size(mask));
        end
    end
end