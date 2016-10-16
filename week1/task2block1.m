function [ files_train ] = task2block1( directory )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 1 Task 2  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Load the information from the previous task
% cd(directory);
[ Sign_characteristics, Text_files ] = task1block1( directory );
Total_signs = size(Sign_characteristics, 1);

files = size(Text_files, 1);
Files_multiple = cell(files, 1);
idx_multiple = 1;
signs_of_multiple = 0;
%Find the files that contain more than one sign
for i = 1:files
    signs_in_file = sum(strcmp(Sign_characteristics(:, 1), Text_files(i).name(4:length(Text_files(i).name)-4)));
    if  signs_in_file > 1
        Files_multiple(idx_multiple, 1) = {Text_files(i).name(4:length(Text_files(i).name)-4)};
        idx_multiple = idx_multiple + 1;
        signs_of_multiple = signs_of_multiple + signs_in_file;
    end
end
files_mult_count = idx_multiple - 1;
Files_multiple(idx_multiple:files) = [];

Sign_characteristics_single = cell(Total_signs - signs_of_multiple, 5);
Sign_characteristics_multiple = cell(signs_of_multiple, 5);

%Save in separate variable "single" and "multiple" files
idx_multiple = 1;
idx_single = 1;
for i = 1:Total_signs
    signs_in_file = sum(strcmp(Sign_characteristics(:, 1), Sign_characteristics(i, 1)));
    if signs_in_file > 1
        Sign_characteristics_multiple(idx_multiple, :) = Sign_characteristics(i, :);
        idx_multiple = idx_multiple + 1;
    else
        Sign_characteristics_single(idx_single, :) = Sign_characteristics(i, :);
        idx_single = idx_single + 1;
    end
end

%Choose the files to pick from single files
Signs_single_picked = zeros(size(Sign_characteristics_single, 1), 1);

signs_type = zeros(6, 1);

signs_type(1) = sum(strcmp(Sign_characteristics_single(:, 5), 'A'));
signs_type(2) = sum(strcmp(Sign_characteristics_single(:, 5), 'B'));
signs_type(3) = sum(strcmp(Sign_characteristics_single(:, 5), 'C'));
signs_type(4) = sum(strcmp(Sign_characteristics_single(:, 5), 'D'));
signs_type(5) = sum(strcmp(Sign_characteristics_single(:, 5), 'E'));
signs_type(6) = sum(strcmp(Sign_characteristics_single(:, 5), 'F'));

%Calculate the index where the type of sign changes
prev_signs = zeros(7, 1);
prev_signs(1) = 0;
for i = 2:7
    prev_signs(i) = prev_signs(i - 1) + signs_type(i - 1);
end

%First, we will sort the signs for each type and later for its size
Signs_single_sorted = sortrows(Sign_characteristics_single, 5);
for i = 1:6
    Signs_single_sorted(prev_signs(i) + 1:prev_signs(i+1), :) = sortrows(Signs_single_sorted(prev_signs(i) + 1:prev_signs(i+1) , :), 2);
end


Files_picked = containers.Map;
for i = 1:files
    Files_picked(Text_files(i).name(4:length(Text_files(i).name)-4)) = 0;
end


%We will choose the signs for train set in the following: for each 10
%signs, the first seven will be for train and the other 3 for validate

for j = 1:6
    for i = 1:floor(signs_type(j)/10)
        %Mark the signs picked
        Signs_single_picked(((i - 1)*10 + 1 + prev_signs(j)):(i - 1)*10 + 7 + prev_signs(j)) = ones(7, 1);
    end
    left = signs_type(j) - 10*floor(signs_type(j)/10);
    Signs_single_picked(floor(signs_type(j)/10)*10 + 1 + prev_signs(j):floor(signs_type(j)/10)*10 + round(0.7*left + prev_signs(j))) = ones(round(0.7*left), 1);
end

%Mark the files to pick for the training set
for i = 1:Total_signs - signs_of_multiple
    if Signs_single_picked(i) == 1
        Files_picked(char(Signs_single_sorted(i, 1))) = 1;
    end
end

%Compute the signs telft to pick, that will be picked from the multiple
%files
Signs_train = round(0.7*(Total_signs));
left_to_pick = Signs_train - sum(Signs_single_picked);

signs_mult_count = size(Sign_characteristics_multiple, 1);
Signs_multiple_picked = zeros(signs_mult_count, 1);
Signs_cant_pick = zeros(signs_mult_count, 1);

signs_type = zeros(6, 1);

signs_type(1) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'A'));
signs_type(2) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'B'));
signs_type(3) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'C'));
signs_type(4) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'D'));
signs_type(5)= sum(strcmp(Sign_characteristics_multiple(:, 5), 'E'));
signs_type(6) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'F'));


prev_signs = zeros(7, 1);
prev_signs(1) = 0;
for i = 2:7
    prev_signs(i) = prev_signs(i - 1) + signs_type(i - 1);
end

%First, we will sort the signs for each type and later for its size
Signs_multiple_sorted = sortrows(Sign_characteristics_multiple, 5);
for i = 1:6
    Signs_multiple_sorted(prev_signs(i) + 1:prev_signs(i+1), :) = sortrows(Signs_multiple_sorted(prev_signs(i) + 1:prev_signs(i+1) , :), 2);
end

%The multiple files are picked "randomly", starting from the signs with                                                                                124
%lower area
last_picked = zeros(6, 1);
finished = 0;
while not(finished)
    %While we need more signs to pick
    for j = 1:6
        %In each iteration we will take the first sign not picked
        if last_picked(j) == -1
            continue
        else
            if last_picked(j) == signs_type(j)
                last_picked(j) = -1;
                continue
            end
        end
        %Take the index of the first sign in a type that we can take
        idx = last_picked(j) + 1 + prev_signs(j);
        while (Signs_cant_pick(idx, 1) == 1 || Signs_multiple_picked(idx, 1) == 1) && idx <= prev_signs(j + 1)
            idx = idx + 1;
        end
        if idx > prev_signs(j + 1)
            last_picked(j) = -1;
            continue
        end
        
        Signs_multiple_picked(idx, 1) = 1;
        
        %Calculate the number of signs to pick if we pick the file that
        %contains the sign idx
        signs_to_add = 0;
        for i = 1:signs_mult_count
            if char(Signs_multiple_sorted(i, 1)) == char(Signs_multiple_sorted(idx, 1))
                signs_to_add = signs_to_add + 1;
            end
        end
        
        %We will admit to take a sign less or more than the expected
        if left_to_pick - signs_to_add >= -1
            Files_picked(char(Signs_multiple_sorted(idx, 1))) = 1;
            for i = 1:signs_mult_count
                if char(Signs_multiple_sorted(i, 1)) == char(Signs_multiple_sorted(idx, 1))
                    Signs_multiple_picked(i, 1) = 1;
                end
            end
            left_to_pick = left_to_pick - signs_to_add;
            if abs(left_to_pick) <= 1
                finished = 1;
            end
        else
            %We cant take this signs, because we will pick more than the needed
            Signs_cant_pick(idx, 1) = 1;
            Signs_multiple_picked(idx, 1) = 0;
            for i = 1:signs_mult_count
                if char(Signs_multiple_sorted(i, 1)) == char(Signs_multiple_sorted(idx, 1))
                    Signs_cant_pick(i, 1) = 1;
                end
            end
        end
        
        if sum(Signs_cant_pick) == signs_type(j)
            last_picked(j) = -1;
        end
    end
    if sum(last_picked) == -6
        finished = 1;
    end
end


names_files = keys(Files_picked);

names_files_train = cell(sum(cell2mat(values(Files_picked))), 1);
idx = 1;
files_to_delete = [];
for i = 1:files
    if Files_picked(char(names_files(i))) == 1
        % If the file is marked as picked
        Text_files(i).name = Text_files(i).name(4:length(Text_files(i).name)-4);
        names_files_train(idx) = {names_files(i)};
        idx = idx + 1;
    else
        files_to_delete = [i files_to_delete]; 
    end
end

files_train = Text_files;
for i = 1:size(files_to_delete, 2)
    files_train(files_to_delete(i)) = [];
    
end    

save('Results/names_files_train', 'files_train');
end