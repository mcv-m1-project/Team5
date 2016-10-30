function [ Characteristics ] = trainSC_Window( SC_train )

%Obtain characteristics of means, maxs and mins fo the sign of train set

%1: File where the sign appears
%2: Area of the bounding box containing the sign
%3: form factor = width/height
%4: filling ratio = mask_area / bbox_area
%5: type of sign
%6: Coordinates of the sign in the image

%-Type of signals:
%A, B: triangles
%C, D, E: circles
%F: squares

value = num2cell(zeros( 3, 1));

Type_index = [1 2 0; 3 4 5; 6 0 0];

SC_train_sorted = sortrows(SC_train, 5);

types = unique(SC_train_sorted(:, 5));
signs_type = zeros(size(types, 1), 1);
prev_signs = zeros(size(types, 1) + 1, 1);

prev_signs(1) = 0;
for i = 1:size(types, 1)
    signs_type(i) = sum(strcmp(SC_train_sorted(:, 5), char(types(i))));
    prev_signs(i + 1) = prev_signs(i) + signs_type(i);
end    

Characteristics = struct('min_w', value, 'max_w', value, 'min_h',value, 'max_h', value,...
     'mean_form_factor', value, 'std_form_factor', value, 'min_fill_ratio', value, 'max_fill_ratio', value,...
     'mean_fill_ratio', value, 'std_fill_ratio', value);


for i = 1:3
    typ_idx = Type_index(i, :);
    typ_idx( :, all(~typ_idx, 1) ) = [];
    num_signs = sum(signs_type(typ_idx));
    W_and_H = zeros(num_signs, 2);
    for j = prev_signs(typ_idx(1)) + (1:num_signs)
        dims_sign = SC_train_sorted{j,6};
        W_and_H(j - prev_signs(typ_idx(1)), :) = [dims_sign.w dims_sign.h];        
    end   
    Characteristics(i).min_w = min(W_and_H(:, 1));
    Characteristics(i).max_w = max(W_and_H(:, 1));
    
    Characteristics(i).min_h = min(W_and_H(:, 2));
    Characteristics(i).max_h = max(W_and_H(:, 2));
    
    Characteristics(i).mean_form_factor = mean(cell2mat(SC_train_sorted(prev_signs(typ_idx(1)) + 1:prev_signs(typ_idx(end) + 1), 3)));
    Characteristics(i).std_form_factor = mean(cell2mat(SC_train_sorted(prev_signs(typ_idx(1)) + 1:prev_signs(typ_idx(end) + 1), 3)));
    
    Characteristics(i).min_fill_ratio = min(cell2mat(SC_train_sorted(prev_signs(typ_idx(1)) + 1:prev_signs(typ_idx(end) + 1), 4)));
    Characteristics(i).max_fill_ratio = max(cell2mat(SC_train_sorted(prev_signs(typ_idx(1)) + 1:prev_signs(typ_idx(end) + 1), 4)));
    
    Characteristics(i).mean_fill_ratio = mean(cell2mat(SC_train_sorted(prev_signs(typ_idx(1)) + 1:prev_signs(typ_idx(end) + 1), 4)));
    Characteristics(i).std_fill_ratio = std(cell2mat(SC_train_sorted(prev_signs(typ_idx(1)) + 1:prev_signs(typ_idx(end) + 1), 4)));
end    
end

