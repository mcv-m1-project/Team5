function [ Thre ] = Thresholds_hough( SC_train )
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


%Compute the min side and max diagonal for all rectangles

typ_idx = Type_index(3, :);
typ_idx( :, all(~typ_idx, 1) ) = [];
num_signs = sum(signs_type(typ_idx));
W_and_H = zeros(num_signs, 2);
Diag = zeros(num_signs, 1);
for j = prev_signs(typ_idx(1)) + (1:num_signs)
    dims_sign = SC_train_sorted{j, 6};
    W_and_H(j - prev_signs(typ_idx(1)), :) = [dims_sign.w dims_sign.h];
    Diag(j - prev_signs(typ_idx(1))) = sqrt(dims_sign.w^2 +  dims_sign.h^2);
end


Thre = struct('min_D_rect', round(min(W_and_H(:))), ...
              'max_D_rect', round(max(Diag)), ...
              'd_theta', 0, ...
              'd_rho', 3/4, ...
              'T_c', 0, ...
              'T_theta', 3, ...
              'T_rho', 3,  ...
              'T_L', 0.3, ...
              'T_alpha', 3,...
              'a', 1, ...
              'b', 4);
          
Thre.d_theta = (3*pi)/(4*Thre.max_D_rect);
Thre.T_c = 0.5*Thre.min_D_rect;

end

