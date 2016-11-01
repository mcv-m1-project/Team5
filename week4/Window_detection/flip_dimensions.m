function [ new_BBox ] = flip_dimensions( BBox )


new_BBox = BBox;
for i = 1:size(BBox, 1)
    new_BBox(i).x = BBox(i).y;
    new_BBox(i).y = BBox(i).x;
    new_BBox(i).h = BBox(i).w;
    new_BBox(i).w = BBox(i).h;
end    
end

