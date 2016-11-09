function [ params, files, SC_train ] = compute_paremeters_w3( directory_results, directory_images, set_type )

params = struct('directory_read_mask', '', 'directory_read_BBox', '', ...
    'directory_write_results', '', 'type_set', '', 'colorSpace', 0);

params.type_set = set_type;
params.directory_read_mask = strcat(directory_results, '/week_02/', params.type_set, '_result');
params.directory_write_results = strcat(directory_results, '/week_03/', params.type_set, '_result');

if ~exist(params.directory_write_results, 'dir')
  mkdir(params.directory_write_results);
end

if ~strcmp(params.type_set, 'test')
    params.directory_read_BBox = strcat(directory_images, '/train/gt/');
else
    params.directory_read_BBox = strcat(directory_images, '/test');
end    


%Compute the list of files
if strcmp(params.type_set, 'test')
    files_test = ListFiles(params.directory_read_BBox);
    for i = 1:size(files_test)
        files_test(i).name = files_test(i).name(1:length(files_test(i).name)-4);
    end
    files = files_test;
else
    if strcmp(params.type_set, 'train')
        load(strcat(directory_results, '/week_01/names_files_train'), 'files_train'); 
        files = files_train;
    else
        load(strcat(directory_results, '/week_01/names_files_validate'), 'files_validate'); 
        files = files_validate;
    end
end



SC_train = load(strcat(directory_results, '/week_01/Sign_characteristics_train')); 

SC_train = SC_train.SC_train;

end

