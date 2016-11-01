clear all
close all
clc
addpath('./Window_detection');
addpath('./evaluation');
%Directory where the masks of the different sets are placed
directory_read_results = '../Results';
directory_all_images = '../Images';
directory_write = '../Results/week_03';

%Set to evaluate: train, validate or test
set_type = 'validate';


params = struct('directory_read_mask', '', 'directory_read_BBox', '', ...
    'directory_write_results', '', 'type_set', '', 'colorSpace', 0);

params.type_set = set_type;
params.directory_read_mask = strcat(directory_read_results, '/week_02/', params.type_set, '_result');
params.directory_write_results = strcat(directory_read_results, '/week_03/', params.type_set, '_result');

if ~strcmp(params.type_set, 'test')
    params.directory_read_BBox = strcat(directory_all_images, '/train/gt/');
else
    params.directory_read_BBox = strcat(directory_all_images, '/test');
end    

      
load(strcat(directory_read_results, '/week_01/Sign_characteristics_train')); 


%Names of the different methods we have used for the segmentation
colorSpaces = { 'HSV'  'HSV&RGB' };
colorSp = [       1        2    ];
%We create the colorSp vector because the switch works better with numbers
% %Names of the different methods we have used for the segmentation
% methods = { 'HSV_SW' 'HSV&RGB_SW' };
% meth = [      1         2       ];

%Compute the list of files
if strcmp(params.type_set, 'test')
    files_test = ListFiles(params.directory_read_BBox);
    for i = 1:size(files_test)
        files_test(i).name = files_test(i).name(1:length(files_test(i).name)-4);
    end
    files = files_test;
else
    if strcmp(params.type_set, 'train')
        load(strcat(directory_read_results, '/week_01/names_files_train'), 'files_train'); 
        files = files_train;
    else
        load(strcat(directory_read_results, '/week_01/names_files_validate'), 'files_validate'); 
        files = files_validate;
    end
end

%%

[ Characteristics ] = trainSC_Window( SC_train );
metrix_methods = zeros(7, 2);
for i = 1:2
    params.colorSpace = colorSp(i);
    metrix = SignDetectionCCL( params, files, Characteristics );
    if ~isempty(metrix)
        metrix_methods(:, i) = metrix;
    end
end

sprintf('train')

