function windowCandidates=TemplateMatchingCorrelationCCL(im,mask,wc,templates,corr_threshold)
    windowCandidates = [];
    im(~mask)=0;
    
    correlation=cell(length(templates),1);
    for i=1:length(wc)
        for j=1:length(templates)
            rt=imresize(templates{j},[wc(i).h wc(i).w]);%Resized template
            signCandidate=im(round(wc(i).y):round(wc(i).y+wc(i).h-1),round(wc(i).x):round(wc(i).x+wc(i).w-1));%Candidate to be a Sign (grayscale)
            correlation{j} = normxcorr2(rt,signCandidate);
        end
        if max(cellfun(@(x) max(x(:)), correlation))>corr_threshold
            windowCandidates=[windowCandidates;wc(i)];
        end
    end
end