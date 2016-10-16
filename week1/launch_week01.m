
%Directory where the images of the train images are placed
directory = './train';

%Names of the different methods we have used for the segmentation
colorSpaces = {'RGBManual' 'OtsuRGB' 'HSV' 'Lab' 'YUV' 'HSV&RGB'};
colorSp = [         1           2      3     4     5        6   ];
%We create the colorSp vector because the switch works better with numbers

metrix_methods = zeros(10, 6);
%Compute the files of the train set
[ files_train ] = task2block1( directory );
%Evaluate all methods ans save its metrices
for i = 1:6
    pixel_method = colorSp(i);
    metr_method = SignDetection(pixel_method , files_train, directory );
    metrix_methods(:, i) = metr_method;
end
metrix_methods(:, i) = metr_method;