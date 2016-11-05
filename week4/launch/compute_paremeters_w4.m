function [ params, files, templates] = compute_paremeters_w4( directory_results, directory_images, set_type, directory_templates )

params = struct('directory_read_mask', '', ...
    'directory_read_images', '', ...
    'directory_write_results', '',...
    'directory_read_BBox', '',...
    'type_set', '', 'method', 1);

params.type_set = set_type;
params.directory_read_mask = strcat(directory_results, '/week_02/', params.type_set, '_result');
params.directory_read_BBox = strcat(directory_results, '/week_03/', params.type_set, '_result');
params.directory_write_results = strcat(directory_results, '/week_04/', params.type_set, '_result');

% params.directory_read_templates = directory_templates;

if ~exist(params.directory_write_results, 'dir')
  mkdir(params.directory_write_results);
end

if ~strcmp(params.type_set, 'test')
    params.directory_read_images = strcat(directory_images, '/train/');
else
    params.directory_read_images = strcat(directory_images, '/test/');
end    


%Compute the list of files
if strcmp(params.type_set, 'test')
    files_test = ListFiles(params.directory_read_images);
    for i = 1:size(files_test)
        files_test(i).name = files_test(i).name(1:end - 4);
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

templates = computeTrainTemplates(directory_templates, strcat(directory_images, filesep, 'train'));

end

