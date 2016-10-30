function [ validate ] = Validate_window( Window, Char )
validate = 0;
detection = sum(Window(:));
box = size(Window, 1)*size(Window, 2);
filling = detection/box;

if filling > Char.min_fill_ratio && filling < Char.max_fill_ratio
    validate = 1;
end

end

