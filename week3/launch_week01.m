addpath('./dataset_split');
addpath('./color_segmentation');

%Directory where the images of the train set are placed
directory_read_train = '../Images/train';
directory_write = '../Results/week_01';
if ~exist(directory_write,'dir')
  mkdir(directory_write);
end
%Directory where the images of the test set are placed
directory_read_test = '../Images/test';
%Path where the results are written

%Names of the different methods we have used for the segmentation
colorSpaces = {'RGBManual' 'OtsuRGB' 'HSV' 'Lab' 'YUV' 'HSV&RGB' 'histBP'};
colorSp = [         1           2      3     4     5        6       7];
%We create the colorSp vector because the switch works better with numbers

% Compute the files of the train set
[ files_train, files_validate ] = task2block1( directory_read_train, directory_write );
%Computes and saves the 2D histogram for each group of signs using the training dataset
nbins=[50,50];%Number of bins for the 2D histogram
histogramBackProjectionTrain(nbins,directory_write,directory_read_train);

%%
%Evaluate all methods ans save its metrices for train set
metrix_methods_train = zeros(10, length(colorSp));
directory_write = '../Results/week_01/train_result';
for i = 1:length(colorSp)
    pixel_method = colorSp(i);
    metr_method = SignDetection(pixel_method , files_train, directory_read_train, directory_write );
    metrix_methods_train(:, i) = metr_method;
end
metrix_methods_train(:, i) = metr_method;
save(strcat(directory_write, '/metrix_methods_train'), 'metrix_methods_train');

%%
%Evaluate all methods ans save its metrices for validate set
directory_write = '../Results/week_01/validate_result';
metrix_methods_validate = zeros(10, length(colorSp));
for i = 1:length(colorSp)
    pixel_method = colorSp(i);
    metr_method = SignDetection(pixel_method , files_validate, directory_read_train, directory_write);
    metrix_methods_validate(:, i) = metr_method;
end
metrix_methods_validate(:, i) = metr_method;
save(strcat(directory_write, '/metrix_methods_validate'), 'metrix_methods_validate');
%%
% Evaluate all methods for the test set
directory_write = '../Results/week_01/test_result';
files_test = ListFiles(directory_read_test);
for i = 1:size(files_test)
    files_test(i).name = files_test(i).name(1:length(files_test(i).name)-4);
end   
for i = 1:length(colorSp)
    pixel_method = colorSp(i);
    average_time = Task3block1(directory_read_test, files_test, directory_write, pixel_method);
end
%%
%Evaluate all methods ans save its metrices for test set (you need masks)
directory_write = '../Results/week_01/test_result';
files_test = ListFiles(directory_read_test);
for i = 1:size(files_test)
    files_test(i).name = files_test(i).name(1:length(files_test(i).name)-4);
end    

metrix_methods_test = zeros(10, length(colorSp));
for i = 1:length(colorSp)
    pixel_method = colorSp(i);
    metr_method = SignDetection(pixel_method , files_test, directory_read_test, directory_write );
    metrix_methods_test(:, i) = metr_method;
end
metrix_methods_test(:, i) = metr_method;
save('../Results/metrix_methods_test', 'metrix_methods_test');