function [ new_BBox, exist ] = Adjust_window( BBox, Mask )

exist = 1;
x = BBox.x;
y = BBox.y;
h = BBox.h;
w = BBox.w;
Window = Mask(y:w + y, x:h + x);

c1 = 1;
c2 = size(Window, 2);
r1 = 1;
r2 = size(Window, 1);

not_adjusted = 1;
del_c1 = 0;
del_c2 = 0;
del_r1 = 0;
del_r2 = 0;

while not_adjusted
    not_adjusted = not(del_c1 && del_c2 && del_r1 && del_r2);
    %Delete left column
    if sum(Window(:, c1)) == 0
        c1 = c1 + 1;
        if c1 == c2
            exist = 0;
            break
        end    
    else
        del_c1 = 1;
    end    
    %Delete up row
    if sum(Window(r1, :)) == 0
        r1 = r1 + 1;
        if r1 == r2
            exist = 0;
            break
        end    
    else
        del_r1 = 1;
    end 
    %Delete right column
    if sum(Window(:, c2)) == 0
        c2 = c2 - 1;
        if c1 == c2
            exist = 0;
            break
        end    
    else
        del_c2 = 1;
    end 
    %Delete down row
    if sum(Window(r2, :)) == 0
        r2 = r2 - 1;
        if r1 == r2
            exist = 0;
            break
        end    
    else
        del_r2 = 1;
    end 
end    
    

new_BBox = struct('x', x + c1 - 1, 'y', y +r1 - 1, 'w', c2 - c1 , 'h', r2 - r1 );
end

