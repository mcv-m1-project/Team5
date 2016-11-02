function [ empty ] = Connected_components(params, files , SC_train)

%Use the training set as a reference for the filling ratio, etc to discard
%false positives
train_param = trainSignCharacteristicsCCL(SC_train);

 
%Get Bounding Boxes by Connected Component Labeling
   
    for i = 1:length(files)
        mask = imread(strcat(params.directory_read_mask, filesep, files(i).name, '_morf.png'));
        windowCandidates = CCL(mask, train_param);
        save(strcat(params.directory_write_results, filesep, files(i).name, '_mask.mat'), 'windowCandidates');
    end

empty = [];
end

