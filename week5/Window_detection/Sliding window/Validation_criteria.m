function [ validation_crit ] = Validation_criteria( SC_train )

a = 3;

SC_train_sorted = sortrows(SC_train, 5);
signs_type = zeros(6, 1);

signs_type(1) = sum(strcmp(SC_train_sorted(:, 5), 'A'));
signs_type(2) = sum(strcmp(SC_train_sorted(:, 5), 'B'));
signs_type(3) = sum(strcmp(SC_train_sorted(:, 5), 'C'));
signs_type(4) = sum(strcmp(SC_train_sorted(:, 5), 'D'));
signs_type(5) = sum(strcmp(SC_train_sorted(:, 5), 'E'));
signs_type(6) = sum(strcmp(SC_train_sorted(:, 5), 'F'));

prev_signs = zeros(7, 1);
prev_signs(1) = 0;
for i = 2:7
    prev_signs(i) = prev_signs(i - 1) + signs_type(i - 1);
end


% max_triangles = max(cell2mat(SC_train_sorted(1:prev_signs(3), 4)));
% min_triangles = min(cell2mat(SC_train_sorted(1:prev_signs(3), 4)));

mean_triangles = mean(cell2mat(SC_train_sorted(1:prev_signs(3), 4)));
std_triangles = std(cell2mat(SC_train_sorted(1:prev_signs(3), 4)));

mean_circles = mean(cell2mat(SC_train_sorted(prev_signs(3) + 1:prev_signs(6), 4)));
std_circles = std(cell2mat(SC_train_sorted(prev_signs(3) + 1:prev_signs(6), 4)));

mean_squares = mean(cell2mat(SC_train_sorted(prev_signs(6) + 1:prev_signs(7), 4)));
std_squares = std(cell2mat(SC_train_sorted(prev_signs(6) + 1:prev_signs(7), 4)));

validation_crit = [mean_triangles - a*std_triangles   mean_triangles + a*std_triangles;...
    mean_circles - a*std_circles   mean_circles + a*std_circles;...
    mean_squares - a*std_squares   mean_squares + a*std_squares];

end

% hist(cell2mat(SC_train_sorted(1:prev_signs(3), 4)));
% figure, hist(cell2mat(SC_train_sorted(prev_signs(3) + 1:prev_signs(6), 4)));
% figure, hist(cell2mat(SC_train_sorted(prev_signs(6) + 1:prev_signs(7), 4)));
% figure, hist(cell2mat(SC_train_sorted(:, 4)));