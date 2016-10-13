%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 1 Task 1  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
%Add folders of functions to path
addpath('./evaluation')
addpath('./colorspace')
addpath('./circular_hough')


%Read txt files from the directory of the ground truth files
Folder_gt = './train/gt';
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

%First image
[annotations, Signs] = LoadAnnotations(strcat(Folder_gt, '/', Text_files(1).name));
ii=size(annotations, 1);
Sign_characteristics(1:ii,1)={Text_files(1).name(4:length(Text_files(1).name)-4)};
Sign_characteristics(1:ii,2)=num2cell(([annotations(:).w].*[annotations(:).h]));
Sign_characteristics(1:ii,3)=num2cell(([annotations(:).w]./[annotations(:).h]));
Sign_characteristics(1:ii,5)=Signs(:);
mask = double(imread(strcat('./train/mask/mask.', Sign_characteristics{1,1}, '.png')));
for j=1:ii
    mask_area=sum(sum(mask(round(annotations(j).y):round(annotations(j).y+annotations(j).h),round(annotations(j).x):round(annotations(j).x+annotations(j).w))>0));
    Sign_characteristics(j,4)={mask_area/Sign_characteristics{j,2}};
end

%For each image
for i = 2:length(Text_files)%Por que empieza en 2??
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
    mask = double(imread(strcat('./train/mask/mask.', Sign_characteristics{ii+1,1}, '.png')));
    for j=1:signs_number
        mask_area=sum(sum(mask(round(annotations(j).y):round(annotations(j).y+annotations(j).h),round(annotations(j).x):round(annotations(j).x+annotations(j).w))>0));
        Sign_characteristics(ii+j,4)={mask_area/Sign_characteristics{ii+j,2}};
    end

    %Char 5: Sign type
    Sign_characteristics(ii+1:ii+signs_number,5)=Signs(:);
    
    ii=ii+signs_number;
end

%Remove signs without mask
Sign_characteristics=Sign_characteristics([[Sign_characteristics{:,4}]~=0]',:);


% %Creamos una matriz donde se guardaran los filename en orden en función
% %a su tamaño (de menor área de bounding box a mayor en cada columna) y
% %en 6 filas en función al tipo de señal (A,B,C,D,E,F), así como
% %vectores auxiliares para cada tipo.
% 
% auxA = {};
% auxB = {};
% auxC = {};
% auxD = {};
% auxE = {};
% auxF = {};
% 
% 
% %For all the files read
% for i = 1:length(archivos)
%     
%     %Ensure the file is a .txt
%     if archivos(i).isdir == 0,
%         if strcmp(archivos(i).name(end-2:end),'txt') == 1
%             
%             name = archivos(i).name;
%             name = strcat(NewFolder, '/', name);
%             %Open file and read line
%             fileID = fopen(name, 'r');
%             tline = fgetl(fileID);
%             
%             if (strfind(tline,'A') ~= 0)
%                 auxA{end + 1} = name;
%                 
%             elseif (strfind(tline,'B') ~= 0)
%                 auxB{end + 1} = name;
%                 
%             elseif (strfind(tline,'C') ~= 0)
%                 auxC{end + 1} = name;
%                 
%             elseif (strfind(tline,'D') ~= 0)
%                 auxD{end + 1} = name;
%                 
%             elseif (strfind(tline,'E') ~= 0)
%                 auxE{end + 1} = name;
%                 
%             elseif (strfind(tline,'F') ~= 0)
%                 auxF{end + 1} = name;
%                 
%             elseif tline == -1
%                 fclose(fileID);
%                 continue;
%             end
%             fclose(fileID);
%         end
%     end
% end

