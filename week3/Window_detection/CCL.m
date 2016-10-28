function windowCandidates = CCL(mask)
%Given an image, returns a list of bounding boxes detected by Connected 
%Component Labeling
windowCandidates = struct('x', [], 'y', [], 'w',[], 'h', []);

CC = bwconncomp(mask);
windowProps=regionprops(CC,'all');

for j=1:size(windowProps,1)    
    %Discard BBs
    discard=discard_CCL_regions(windowProps);
    if ~discard
        windowCandidates(j).x=round(windowProps(j).BoundingBox(1));
        windowCandidates(j).y=round(windowProps(j).BoundingBox(2));
        windowCandidates(j).w=windowProps(j).BoundingBox(3);
        windowCandidates(j).h=windowProps(j).BoundingBox(4);    
    end
end

end