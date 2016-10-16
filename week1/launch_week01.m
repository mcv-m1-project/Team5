
%Directory where the images of the train set are placed
directory = './train';
%Directory where the images of the test set are placed
directory_test = './test';
%Path where the results are written

%Names of the different methods we have used for the segmentation
colorSpaces = {'RGBManual' 'OtsuRGB' 'HSV' 'Lab' 'YUV' 'HSV&RGB'};
colorSp = [         1           2      3     4     5        6   ];
%We create the colorSp vector because the switch works better with numbers

% Compute the files of the train set
[ files_train, files_validate ] = task2block1( directory );


%Evaluate all methods ans save its metrices for train set
metrix_methods_train = zeros(10, 6);
path_images_write = './train_result';
for i = 1:6
    pixel_method = colorSp(i);
    metr_method = SignDetection(pixel_method , files_train, directory, path_images_write );
    metrix_methods_train(:, i) = metr_method;
end
metrix_methods_train(:, i) = metr_method;
save('./Results/metrix_methods_train', 'metrix_methods_train');


%Evaluate all methods ans save its metrices for validate set
path_images_write = './validate_result';
metrix_methods_validate = zeros(10, 6);
for i = 1:6
    pixel_method = colorSp(i);
    metr_method = SignDetection(pixel_method , files_validate, directory, path_images_write);
    metrix_methods_validate(:, i) = metr_method;
end
metrix_methods_validate(:, i) = metr_method;
save('./Results/metrix_methods_validate', 'metrix_methods_validate');

%%
%Evaluate all methods ans save its metrices for test set (you need masks)
path_images_write = './train_test';
files_test = ListFiles(directory_test);
for i = 1:size(files_test)
    files_test(i).name = files_test(i).name(1:length(files_test(i).name)-4);
end    

metrix_methods_test = zeros(10, 6);
for i = 1:1
    pixel_method = colorSp(i);
    metr_method = SignDetection(pixel_method , files_test, directory_test, path_images_write );
    metrix_methods_test(:, i) = metr_method;
end
metrix_methods_test(:, i) = metr_method;
save('./Results/metrix_methods_validate', 'metrix_methods_test');