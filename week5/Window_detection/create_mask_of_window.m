function [ new_mask ] = create_mask_of_window( BBox, Mask )

dim = length(BBox);
dim_mask = size(Mask);
new_mask = (zeros(dim_mask));

if ~isempty(BBox)
    if BBox(1).x ~= 0
        for i = 1:dim
            y = BBox(i).y;
            x = BBox(i).x;
            window_width = BBox(i).w;
            window_height = BBox(i).h;
            new_mask(y:min(window_height + y, dim_mask(1)), x:min(window_width + x, dim_mask(2))) = ...
                Mask(y:min(window_height + y, dim_mask(1)), x:min(window_width + x, dim_mask(2)));
        end
    end
end
end

