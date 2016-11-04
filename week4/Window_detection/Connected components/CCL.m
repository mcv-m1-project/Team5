function windowCandidates = CCL(mask,train_param)
%Given a mask, returns a list of bounding boxes detected by Connected 
%Component Labeling
if max(max(mask))>0
    CC = bwconncomp(mask);
    windowProps=regionprops(CC,'all');

    windowProps=discard_CCL_regions(windowProps,train_param);%Discard BBs
    if size(windowProps,1)==0
        windowCandidates = [];
    else
        for j=size(windowProps,1):-1:1
            x=round(windowProps(j).BoundingBox(1));
            y=round(windowProps(j).BoundingBox(2));
            w=windowProps(j).BoundingBox(3);
            h=windowProps(j).BoundingBox(4);
            new_windowCandidates = struct('x', x, 'y', y, 'w',w, 'h', h);
            windowCandidates(j)=new_windowCandidates;
        end
        windowCandidates = windowCandidates';
    end
    
else
    windowCandidates = [];
end

end