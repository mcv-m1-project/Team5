%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 1 Task 2  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Load the information from the previous task
task1block1
clear annotations i ii Signs signs_number

files = size(archivos, 1);
Files_multiple = cell(files, 1);
idx_multiple = 1;
signs_of_multiple = 0;

for i = 1:files
    signs_in_file = sum(strcmp(Sign_characteristics(:, 1), archivos(i).name(4:length(archivos(i).name)-4)));
    if  signs_in_file > 1
        Files_multiple(idx_multiple, 1) = {archivos(i).name(4:length(archivos(i).name)-4)};
        idx_multiple = idx_multiple + 1;
        signs_of_multiple = signs_of_multiple + signs_in_file;
    end
end
files_mult_count = idx_multiple - 1;
Files_multiple(idx_multiple:files) = [];
Sign_characteristics_single = cell(Total_signs - signs_of_multiple, 5);
Sign_characteristics_multiple = cell(signs_of_multiple, 5);

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
%%
%First, we will sort the signs for each type and later for its size
Signs_single_sorted = sortrows(sortrows(Sign_characteristics_single, 5), 2);
%%
Files_picked = containers.Map;
for i = 1:files
    Files_picked(archivos(i).name(4:length(archivos(i).name)-4)) = 0;
end
%sum(cell2mat(values(Files_picked)))

Signs_single_picked = zeros(size(Sign_characteristics_single, 1), 1);
signs_type = zeros(6, 1);
signs_type(1) = sum(strcmp(Sign_characteristics_single(:, 5), 'A'));
% A_train = round(0.7*signs_A);
signs_type(2) = sum(strcmp(Sign_characteristics_single(:, 5), 'B'));
% B_train = round(0.7*signs_B);
signs_type(3) = sum(strcmp(Sign_characteristics_single(:, 5), 'C'));
% C_train = round(0.7*signs_C);
signs_type(4) = sum(strcmp(Sign_characteristics_single(:, 5), 'D'));
% D_train = round(0.7*signs_D);
signs_type(5) = sum(strcmp(Sign_characteristics_single(:, 5), 'E'));
% E_train = round(0.7*signs_E);
signs_type(6) = sum(strcmp(Sign_characteristics_single(:, 5), 'F'));
% F_train = round(0.7*signs_F);

prev_signs = zeros(6, 1);
prev_signs(1) = 0;
for i = 2:6
    prev_signs(i) = prev_signs(i - 1) + signs_type(i - 1);
end    

%We will choose the signs for train set in the following: for each 10
%signs, the first seven will be for train and the other 3 for validate

for j = 1:6
    for i = 1:floor(signs_type(j)/10)
        %Mark the signs picked
        Signs_single_picked(((i - 1)*10 + 1 + prev_signs(j)):(i - 1)*10 + 7 + prev_signs(j)) = ones(7, 1);
    end
    left = signs_type(j) - floor(signs_type(j)/10);
    Signs_single_picked(floor(signs_type(j)/10)*10 + 1 + prev_signs(j):floor(signs_type(j)/10)*10 + round(0.7*left + prev_signs(j))) = ones(round(0.7*left), 1);
end

for i = 1:Total_signs - signs_of_multiple
    if Signs_single_picked(i) == 1
        Files_picked(char(Signs_single_sorted(i, 1))) = 1;
    end
end

%%
Files_train = round(0.7*(files));
left_to_pick = Files_train - sum(Signs_single_picked);
signs_mult_count = size(Sign_characteristics_multiple, 1);
Signs_multiple_picked = zeros(signs_mult_count, 1);
Signs_cant_pick = zeros(signs_mult_count, 1);
Signs_multiple_sorted = sortrows(sortrows(Sign_characteristics_multiple, 5), 2);

signs_type = zeros(6, 1);

signs_type(1) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'A'));
A_train = round(0.7*signs_A);
signs_type(2) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'B'));
B_train = round(0.7*signs_B);
signs_type(3) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'C'));
C_train = round(0.7*signs_C);
signs_type(4) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'D'));
D_train = round(0.7*signs_D);
signs_type(5)= sum(strcmp(Sign_characteristics_multiple(:, 5), 'E'));
E_train = round(0.7*signs_E);
signs_type(6) = sum(strcmp(Sign_characteristics_multiple(:, 5), 'F'));
F_train = round(0.7*signs_F);

prev_signs = zeros(6, 1);
prev_signs(1) = 0;
for i = 2:6
    prev_signs(i) = prev_signs(i - 1) + signs_type(i - 1);
end  

last_picked = zeros(6, 1);
finished = 0;
while not(finished)
    %In each iteration we will take the first sign not picked
    for j = 1:6
        if last_picked(j) == -1
           continue
        else
            if last_picked(j) == signs_type(j)
                last_picked(j) = -1;
                continue
            end    
        end    
        idx = last_picked(j) + 1;
        while Signs_cant_pick(idx, 1) == 1 || idx <= signs_type(j)
            idx = idx + 1;
        end   
        if idx > signs_type(j)
            last_picked(j) = -1;
            continue
        end    

        Signs_multiple_picked(idx, 1) = 1;
        
        signs_to_add = 1;
        for i = 1:signs_mult_count
            if char(Sign_characteristics(i, 1)) == char(Sign_characteristics(idx, 1))
                signs_to_add = signs_to_add + 1;
            end
        end
        
        %We will admit to take a sign less or more than the expected
        if left_to_pick - signs_to_add >= -1
            Files_picked(char(Sign_characteristics(idx, 1))) = 1;
            for i = 1:signs_mult_count
                if char(Sign_characteristics(i, 1)) == char(Sign_characteristics(idx, 1))
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
                if char(Sign_characteristics(i, 1)) == char(Sign_characteristics(idx, 1))
                    Signs_cant_pick(i, 1) = 1;
                end
            end
        end
        
        if sum(Signs_cant_pick) == signs_type(j)
            last_picked(j) = -1;
        end    
        
    end    
end


%%

% %Mark the files of the previous signs
% for i = 1:signs_A
%     if Signs_picked(i) == 1
%         Files_picked(char(Sign_characteristics(i, 1))) = 1;
%     end
% end
% 
% %Some other signs will be already picked, because its file contains an
% %A-sign
% for i = 1:Total_signs
%     if Files_picked(char(Sign_characteristics(i, 1))) == 1
%         Signs_picked(i) = 1;
%     end
% end
% prev_signs = signs_A;
% %Calculate the number of B-signs already picked
% 
% already_pick_B = sum(Signs_picked((1:signs_B) + signs_A, 1));
% 
% if already_pick_B == 0
%     for i = 1:floor(signs_B/10)
%         %Mark the signs picked
%         Signs_picked(((i - 1)*10 + 1 + prev_signs):(i - 1)*10 + 7 + prev_signs) = ones(7, 1);
%     end
%     left_B = signs_B - floor(signs_B/10)*10;
%     Signs_picked(floor(signs_B/10)*10 + 1 + prev_signs:floor(signs_B/10)*10 + round(0.7*left_B) + prev_signs) = ones(round(0.7*left_B), 1);
%     
% else
%     much_signs = 0;
%     if already_pick_B < B_train
%         for i = 1:floor(signs_B/10)
%             %Calculate how many picked signs there are in this "pack" of 10
%             picked_in_pack = sum(Signs_picked(((i - 1)*10 + 1 + prev_signs):i*10 + prev_signs));
%             if picked_in_pack > 7
%                 %If too much, the next "pack" will take less
%                 much_signs = much_signs + (picked_in_pack - 7);
%             else
%                 if picked_in_pack < 7
%                     if 7 - picked_in_pack < much_signs
%                         
%                     else
%                         
%                     end    
%                 end
%                 %If 7, dont do anything
%             end
%         end
%         left_B = signs_B - floor(signs_B/10)*10;
%         Signs_picked(floor(signs_B/10)*10 + 1 + prev_signs:floor(signs_B/10)*10 + round(0.7*left_B) + prev_signs) = ones(round(0.7*left_B), 1);
%     else
%         
%     end
% end



% for i = 1:floor(signs_A/10)
%     %Mark the signs picked
%     Signs_single_picked(((i - 1)*10 + 1):(i - 1)*10 + 7) = ones(7, 1);
% end
% left_A = signs_A - floor(signs_A/10)*10;
% Signs_single_picked(floor(signs_A/10)*10 + 1:floor(signs_A/10)*10 + round(0.7*left_A)) = ones(round(0.7*left_A), 1);
% 
% 
% %Pick B-signs
% prev_signs = signs_A;
% for i = 1:floor(signs_B/10)
%     %Mark the signs picked
%     Signs_single_picked(((i - 1)*10 + 1 + prev_signs):(i - 1)*10 + 7 + prev_signs) = ones(7, 1);
% end
% left_B = signs_B - floor(signs_B/10)*10;
% Signs_single_picked(floor(signs_B/10)*10 + 1 + prev_signs:floor(signs_B/10)*10 + round(0.7*left_B) + prev_signs) = ones(round(0.7*left_B), 1);
% 
% 
% %Pick C-signs
% prev_signs = prev_signs + signs_B;
% for i = 1:floor(signs_C/10)
%     %Mark the signs picked
%     Signs_single_picked(((i - 1)*10 + 1 + prev_signs):(i - 1)*10 + 7 + prev_signs) = ones(7, 1);
% end
% left_C = signs_C - floor(signs_C/10)*10;
% Signs_single_picked(floor(signs_C/10)*10 + 1 + prev_signs:floor(signs_C/10)*10 + round(0.7*left_C) + prev_signs) = ones(round(0.7*left_C), 1);
% 
% 
% %Pick D-signs
% prev_signs = prev_signs + signs_C;
% for i = 1:floor(signs_D/10)
%     %Mark the signs picked
%     Signs_single_picked(((i - 1)*10 + 1 + prev_signs):(i - 1)*10 + 7 + prev_signs) = ones(7, 1);
% end
% left_D = signs_D - floor(signs_D/10)*10;
% Signs_single_picked(floor(signs_D/10)*10 + 1 + prev_signs:floor(signs_D/10)*10 + round(0.7*left_D) + prev_signs) = ones(round(0.7*left_D), 1);
% 
% %Pick E-signs
% prev_signs = prev_signs + signs_D;
% for i = 1:floor(signs_E/10)
%     %Mark the signs picked
%     Signs_single_picked(((i - 1)*10 + 1 + prev_signs):(i - 1)*10 + 7 + prev_signs) = ones(7, 1);
% end
% left_E = signs_E - floor(signs_E/10)*10;
% Signs_single_picked(floor(signs_E/10)*10 + 1 + prev_signs:floor(signs_E/10)*10 + round(0.7*left_E) + prev_signs) = ones(round(0.7*left_E), 1);
% 
% %Pick F-signs
% prev_signs = prev_signs + signs_E;
% for i = 1:floor(signs_F/10)
%     %Mark the signs picked
%     Signs_single_picked(((i - 1)*10 + 1 + prev_signs):(i - 1)*10 + 7 + prev_signs) = ones(7, 1);
% end
% left_F = signs_F - floor(signs_F/10)*10;
% Signs_single_picked(floor(signs_F/10)*10 + 1 + prev_signs:floor(signs_F/10)*10 + round(0.7*left_F) + prev_signs) = ones(round(0.7*left_F), 1);







