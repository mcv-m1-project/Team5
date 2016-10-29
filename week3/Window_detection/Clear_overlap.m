function [ new_BBox ] = Clear_overlap( BBox )
dim = size(BBox);
value = num2cell(zeros(dim));
new_BBox = struct('x', value, 'y', value, 'w', value, 'h', value);
% final_BBox = struct('x', value, 'y', value, 'w', value, 'h', value);
idx_BB = 1;


for i = 1:dim(1)
    if BBox(i).x == 0
        continue
    else
        for j = i + 1:dim(1)
            roi01 = BBox(i);
            roi02 = BBox(j);
            overlap = RoiOverlapping(roi01, roi02);
            %Si dos ventanas se solapan, guardamos la nueva ventana en el
            %lugar de 'i', para seguir probando con las siguientes y
            %eliminamos 'j'
            if overlap > 0.5
                
                BBox(i).x = (roi01.x + roi02.x)/2;
                BBox(i).y = (roi01.y + roi02.y)/2;
                BBox(i).w = (roi01.w + roi02.w)/2;
                BBox(i).h = (roi01.h + roi02.h)/2;
                
                %And delete 'j'
                BBox(j).x = 0;
                BBox(j).y = 0;
                BBox(j).w = 0;
                BBox(j).h = 0;
            end
        end
    end
end
%Guardamos en otra variable los que no hemos eliminado
for i = 1:dim(1)
    if BBox(i).x ~= 0
        
        new_BBox(idx_BB).x = round(BBox(i).x);
        new_BBox(idx_BB).y = round(BBox(i).y);
        new_BBox(idx_BB).w = round(BBox(i).w);
        new_BBox(idx_BB).h = round(BBox(i).h);
        idx_BB = idx_BB + 1;

    end    
end
new_BBox(idx_BB:dim(1)) = [];
end

