set_type = 'validate';
writepath=strcat('../Results/week_05/',set_type,'_result/best_approach');
files_test = dir(strcat(writepath,'/*.png'));
directory_results='../Results';
params.type_set=set_type;
for i = 1:size(files_test)
    files_test(i).name = files_test(i).name(1:length(files_test(i).name)-4);
end
files = files_test;

SC_train = load(strcat(directory_results, '/week_01/Sign_characteristics_train'));
SC_train = SC_train.SC_train;
train_param = trainSignCharacteristicsCCL(SC_train);



hsvpath=strcat('../Results/week_03/',set_type,'_result/HSV_CCL');
hsvfiles=dir(strcat(hsvpath,'/*.png'));
num_files=length(hsvfiles);


TP_images = zeros(num_files, 1);
FP_images = zeros(num_files, 1);
FN_images = zeros(num_files, 1);


Precision_images = zeros(num_files, 1);
Accuracy_images = zeros(num_files, 1);
Sensitivity_images = zeros(num_files, 1);
FMeasure_images = zeros(num_files, 1);

for i = 1:size(files, 1)
    
    mask = imread(strcat(writepath,filesep,hsvfiles(i).name));
    
    windowCandidates = CCL(mask, train_param);
    save(strcat(writepath, filesep, files(i).name(1:end-5), '_mask.mat'), 'windowCandidates');
    
    image_name = files(i).name(1:end-5);
    
    if ~strcmp(params.type_set, 'test')
        
        [windowAnnotation, ~] = LoadAnnotations( strcat('../Images/train/gt/gt.', image_name, '.txt'));
        load(strcat(writepath,filesep, image_name, '_mask.mat'));
        
        [windowTP, windowFN, windowFP] = PerformanceAccumulationWindow(windowCandidates, windowAnnotation);
        [windowPrecision, windowAccuracy, windowSensitivity, windowFMeasure] = PerformanceEvaluationWindow(windowTP, windowFN, windowFP);
        TP_images(i) = windowTP;
        FP_images(i) = windowFP;
        FN_images(i) = windowFN;
        Precision_images(i) = windowPrecision;
        Accuracy_images(i) = windowAccuracy;
        Sensitivity_images(i) = windowSensitivity;
        FMeasure_images(i) = windowFMeasure;
    end
end


if ~strcmp(params.type_set, 'test')
    average_TP = mean(TP_images);
    average_FP = mean(FP_images);
    average_FN = mean(FN_images);
    
    
    Precision_images(isnan(Precision_images))=0;
    Accuracy_images(isnan(Accuracy_images))=0;
    Sensitivity_images(isnan(Sensitivity_images))=0;
    FMeasure_images(isnan(FMeasure_images))=0;
    
    average_Precision = mean(Precision_images);
    average_Accuracy = mean(Accuracy_images);
    average_sensitivity = mean(Sensitivity_images);
    average_FMeasure = mean(FMeasure_images);
    
end
% The vector metrix_method contains the measures of the method
% 1 average_Precision
% 2 average_Accuracy
% 3 average_sensitivity
% 4 average_FMeasure
% 5 average_TP
% 6 average_FP
% 7 average_FN

if ~strcmp(params.type_set, 'test')
    metrix_method = [average_Precision; average_Accuracy; average_sensitivity; average_FMeasure];% average_Specificit];
    metrix_method = [metrix_method; average_TP; average_FP; average_FN];% average_TN; average_time];
else
    metrix_method = [];
    
end