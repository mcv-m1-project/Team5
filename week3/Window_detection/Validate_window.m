function [ validate ] = Validate_window( Window, validation_crit )
validate = 0;
detection = sum(Window(:));
box = size(Window, 1)*size(Window, 2);
filling = detection/box;

if filling > validation_crit(1, 1) && filling < validation_crit(1, 2)
    validate = 1;
end

if filling > validation_crit(2, 1) && filling < validation_crit(2, 2)
    validate = 1;
end

if filling > validation_crit(3, 1) && filling < validation_crit(3, 2)
    validate = 1;
end

end

