function [ new_BBox ] = Clear_overlap( BBox )
dim = size(BBox);
value = num2cell(zeros(dim));
new_BBox = struct('x', value, 'y', value, 'w', value, 'h', value);
idx_BB = 1;
overlaps = zeros(sum(1:dim(1)), 2);
idx_overlap = 1;

graph_overlap = containers.Map(1:dim(1), zeros(dim(1), 1));
components = 0;
%We will find all the windows that are connected, that is, that are
%directly overlaped or there are some intemediate windows that are an
%overlapping chain. 
for i = 1:dim(1)
    for j = i + 1:dim(1)
        roi01 = BBox(i);
        roi02 = BBox(j);
        overlap = RoiOverlapping(roi01, roi02);
        if overlap
            overlaps(idx_overlap) = [i j];
            idx_overlap = idx_overlap + 1;
            if graph_overlap(i) == 0
                components = components + 1;
                graph_overlap(i) = components;
                graph_overlap(j) = components;
            else
                graph_overlap(i) = graph_overlap(j);
            end    
        end    
    end
end
% For each component, the new box will be have vertexs the centroid of all
% the windows
for i = 0:components
    if i == 0
        %The non connected windows are a valid window
        for j = 1:dim(1)
            if graph_overlap(j) == 0
                new_BBox(idx_BB) = BBox(j);
            else
                
            end    
        end    
    else
        
    end    
end    
end

