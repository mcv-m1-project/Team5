function [ metrix_method ] = SignDetectionCorrelation( params, files, templates)


%Set the directories to read and write, according to the method used
switch params.method
    case 1
        corr_threshold=.6;
        run_TM_Correlation_Global(templates,params.directory_write_results,params.directory_read_images,files,corr_threshold);
        
        %Where the .mat files are
        params.directory_write_results = strcat(params.directory_write_results, '/TM_Correlation_Global/');
        
    case 2
        corr_threshold=.65;
        CCL_method='HSV_CCL';
        run_TM_Correlation_CCL(templates,params.directory_write_results,params.directory_read_images,files,corr_threshold,params.directory_read_BBox,CCL_method);
        
        %Where the .mat files are
        params.directory_write_results = strcat(params.directory_write_results, '/TM_Correlation_HSV_CCL/');
    case 3
        corr_threshold=.65;
        CCL_method='HSV&RGB_CCL';
        run_TM_Correlation_CCL(templates,params.directory_write_results,params.directory_read_images,files,corr_threshold,params.directory_read_BBox,CCL_method);
        
        %Where the .mat files are
        params.directory_write_results = strcat(params.directory_write_results, '/TM_Correlation_HSV&RGB_CCL/');
end

%When the BBoxes are computed, if the set is not the test set, we compute
%the metrixes according to the results obtained
if ~strcmp(params.type_set, 'test')
    num_files = size(files, 1);
    TP_images = zeros(num_files, 1);
    FP_images = zeros(num_files, 1);
    FN_images = zeros(num_files, 1);
    %TN_images = zeros(files, 1);
    
    Precision_images = zeros(num_files, 1);
    Accuracy_images = zeros(num_files, 1);
    %Specificit_images = zeros(files, 1);
    Sensitivity_images = zeros(num_files, 1);
    FMeasure_images = zeros(num_files, 1);
    for i = 1:num_files

        image_name = files(i).name;

        [windowAnnotation, ~] = LoadAnnotations(strcat(params.directory_read_images, '/gt/gt.', image_name, '.txt'));
        
        
        %Add extension of the file to load
        load(strcat(params.directory_write_results, image_name, '_mask.mat'));
        
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
    
    
    % The vector metrix_method contains the measures of the method
    % 1 average_Precision
    % 2 average_Accuracy
    % 3 average_sensitivity
    % 4 average_FMeasure
    % % %     % 5 average_Specificit
    % 6 average_TP
    % 7 average_FP
    % 8 average_FN
    % % %     % 9 average_TN
    % % %     % 10 average_time
    
    metrix_method = [average_Precision; average_Accuracy; average_sensitivity; average_FMeasure];% average_Specificit];
    metrix_method = [metrix_method; average_TP; average_FP; average_FN];% average_TN; average_time];
    
else
    metrix_method = [];
    
end
end

