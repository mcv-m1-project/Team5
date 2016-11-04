function windowCandidates = CCL(mask,train_param)
%Given a mask, returns a list of bounding boxes detected by Connected 
%Component Labeling
if max(max(mask))>0
    windowCandidates = struct('x', [], 'y', [], 'w',[], 'h', []);
    CC = bwconncomp(mask);
    windowProps=regionprops(CC,'all');

    windowProps=discard_CCL_regions(windowProps,train_param);%Discard BBs

    for j=size(windowProps,1):-1:1
        windowCandidates(j).x=round(windowProps(j).BoundingBox(1));
        windowCandidates(j).y=round(windowProps(j).BoundingBox(2));
        windowCandidates(j).w=windowProps(j).BoundingBox(3);
        windowCandidates(j).h=windowProps(j).BoundingBox(4);    
    end
    windowCandidates = windowCandidates';
else
    windowCandidates = [];
end

end