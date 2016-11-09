function [ params, files ] = compute_paremeters_w2( directory_results, directory_images, set_type )


params = struct('directory_read_images', '',...
            'directory_read_results', '', ...
            'directory_write_results', '', ...
            'type_set', '', 'colorSpace', 0);

params.type_set = set_type;

if ~exist(strcat(directory_results, '/week_02'), 'dir')
  mkdir(strcat(directory_results, '/week_02'));
end


if ~strcmp(params.type_set, 'test')
    params.directory_read_images = strcat(directory_images, '/train');
else
    params.directory_read_images = strcat(directory_images, '/test');
end

params.directory_read_results = strcat(directory_results, '/week_01/', params.type_set, '_result');
params.directory_write_results = strcat(directory_results, '/week_02/', params.type_set, '_result');

if ~exist(params.directory_write_results, 'dir')
  mkdir(params.directory_write_results);
end



%Compute the list of files
if strcmp(params.type_set, 'test')
    files_test = ListFiles(params.directory_read_images);
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



end

