function [ Sign_characteristics, Text_files ] = task1block1( directory )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 1 Task 1  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Add folders of functions to path
addpath('./evaluation')
addpath('./colorspace')
addpath('./circular_hough')


%Read txt files from the directory of the ground truth files
Folder_gt = strcat(directory, '/gt');
Text_files = dir(strcat(Folder_gt,'/*.txt'));

%First, let's determine the total number of signs
Total_signs = 0;
for i = 1:length(Text_files)
    [annotations, ~] = LoadAnnotations(strcat(Folder_gt,filesep,Text_files(i).name));
    Total_signs = Total_signs + size(annotations, 1);
end


%The characteristics will be saved in a matrix where each row corresponds
%to a sign and the columns are:
%1: File where the sign appears
%2: Area of the bounding box containing the sign
%3: form factor = width/height
%4: filling ratio = mask_area / bbox_area
%5: type of sign

Sign_characteristics = cell(Total_signs, 5);

ii=0;
%For each image
for i = 1:length(Text_files)
    [annotations, Signs] = LoadAnnotations(strcat(Folder_gt, '/', Text_files(i).name));
    signs_number=size(annotations, 1);
    
    %Compute the characteristics
    %Char 1: File name
    Sign_characteristics(ii+1:ii+signs_number,1)={Text_files(i).name(4:length(Text_files(i).name)-4)};
    
    %Char 2: Bounding box area
    Sign_characteristics(ii+1:ii+signs_number,2)=num2cell(([annotations(:).w].*[annotations(:).h]));
    
    %Char 3: Form factor
    Sign_characteristics(ii+1:ii+signs_number,3)=num2cell(([annotations(:).w]./[annotations(:).h]));
    
    %Char 4: Filling ratio
    mask = double(imread(strcat(directory, '/mask/mask.', Sign_characteristics{ii+1,1}, '.png')));
    for j=1:signs_number
        mask_area=sum(sum(mask(round(annotations(j).y):round(annotations(j).y+annotations(j).h),round(annotations(j).x):round(annotations(j).x+annotations(j).w))>0));
        Sign_characteristics(ii+j,4)={mask_area/Sign_characteristics{ii+j,2}};
    end
    
    %Char 5: Sign type
    Sign_characteristics(ii+1:ii+signs_number,5)=Signs(:);
    
    ii=ii+signs_number;
end
mkdir('./Results');
save('./Results/characteristics_signs', 'Sign_characteristics');
end