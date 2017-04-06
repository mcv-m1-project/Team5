files = dir('*.mat');
% Loop through each
for id = 1:length(files)
    % Get the file name (minus the extension)
    [~, name] = fileparts(files(id).name);
      newname=name(1:end-5);
      movefile(files(id).name, strcat(newname,'_mask.mat'));
    
end

files = dir('*.jpg');
% Loop through each
for id = 1:length(files)
    % Get the file name (minus the extension)
    [~, name] = fileparts(files(id).name);
      newname=name(1:end-5);
      movefile(files(id).name, strcat(newname,'_mask.png'));
    
end

files = dir('*.png');
% Loop through each
for id = 1:length(files)
    % Get the file name (minus the extension)
    [~, name] = fileparts(files(id).name);
      newname=name(1:end-5);
      movefile(files(id).name, strcat(newname,'_mask.png'));
    
end