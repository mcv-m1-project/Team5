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
archivos = dir(strcat(Folder_gt,'/*.txt'));

%First, let's determine the total number of signs
Total_signs = 0;
for i = 1:length(archivos)
    [annotations, ~] = LoadAnnotations(strcat(Folder_gt,filesep,archivos(i).name));            
    Total_signs = Total_signs + size(annotations, 1);
end    


%The characteristics will be saved in a matrix where each row corresponds
%to a sign and the columns are:
%1: File where the sign appears
%2: Area of the bound box containing the sign
%3: form factor = width/height
%4: filling ratio = mask_area / bbox_area
%5: type of sign

Sign_characteristics = cell(Total_signs, 5);

%First image
[annotations, Signs] = LoadAnnotations(strcat(Folder_gt, '/', archivos(1).name));
ii=size(annotations, 1);
Sign_characteristics(1:ii,5)=Signs(:);
Sign_characteristics(1:ii,1)={archivos(i).name(4:length(archivos(1).name)-4)};

%For each image
for i = 2:length(archivos)
    [annotations, Signs] = LoadAnnotations(strcat(Folder_gt, '/', archivos(i).name));
    signs_number=size(annotations, 1);
    
    %Compute the characteristics
        
    %Char 1: File name
    Sign_characteristics(ii+1:ii+signs_number,1)={archivos(i).name(4:length(archivos(i).name)-4)};
    
    %Char 2

    %Char 3

    %Char 4

    %Char 5: Sign type
    Sign_characteristics(ii+1:ii+signs_number,5)=Signs(:);
    
    ii=ii+signs_number;
end

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

