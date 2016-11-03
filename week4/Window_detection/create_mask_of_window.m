function [ new_mask ] = create_mask_of_window( BBox, Mask )
dim = length(BBox);
new_mask = (zeros(size(Mask)));
if BBox(1).x ~= 0
    for i = 1:dim
        y = BBox(i).y;
        x = BBox(i).x;
        window_width = BBox(i).w;
        window_height = BBox(i).h;
        new_mask(y:window_width + y, x:window_height + x) = Mask(y:window_width + y, x:window_height + x);
    end
end
end

