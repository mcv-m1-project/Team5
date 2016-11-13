function [ metrix_method ] = SignDetectionHough_pixel_ev( params, files )


%Set the directories to read and write, according to the colorSpace
switch params.colorSpace
    case 1
        params.directory_read_mask = strcat(params.directory_read_mask, '/HSV/');
        params.directory_read_window = strcat(params.directory_read_window, '/HSV_CCL/');
        params.directory_write_results = strcat(params.directory_write_results, '/HSV_CCL_Hough/');
    case 2
        params.directory_read_mask = strcat(params.directory_read_mask, '/histBP/');
        params.directory_read_window = strcat(params.directory_read_window, '/histBP_CCL/');
        params.directory_write_results = strcat(params.directory_write_results, '/HBP_CCL_Hough/');
    case 3
        params.directory_read_mask = strcat(params.directory_read_window, '/UCM2/');
        params.directory_read_window = strcat(params.directory_read_window, '/UCM2/');
        params.directory_write_results = strcat(params.directory_write_results, '/UCM_Hough/');
end

path = params.directory_write_results;
directory = params.directory_read_images;

num_files = size(files, 1);
List_of_images =  files;

if params.compute_metrics
    %When the BBoxes are computed, if the set is not the test set, we compute
    %the metrixes according to the results obtained
    if ~strcmp(params.type_set, 'test')
        TP_images = zeros(num_files, 1);
        FP_images = zeros(num_files, 1);
        FN_images = zeros(num_files, 1);
        TN_images = zeros(num_files, 1);
        
        Precision_images = zeros(num_files, 1);
        Accuracy_images = zeros(num_files, 1);
        Specificit_images = zeros(num_files, 1);
        Sensitivity_images = zeros(num_files, 1);
        FMeasure_images = zeros(num_files, 1);
        
        for i = 1:num_files
            pixelAnnotation = imread(strcat(directory, '/mask/mask.', char(List_of_images(i).name), '.png'));
            
            pixelCandidates = imread(strcat(path, char(List_of_images(i).name), '_mask.png'));
            
            [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(pixelCandidates, pixelAnnotation);
            [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelFMeasure] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
            TP_images(i) = pixelTP;
            FP_images(i) = pixelFP;
            FN_images(i) = pixelFN;
            TN_images(i) = pixelTN;
            Precision_images(i) = pixelPrecision;
            Accuracy_images(i) = pixelAccuracy;
            Specificit_images(i) = pixelSpecificity;
            Sensitivity_images(i) = pixelSensitivity;
            FMeasure_images(i) = pixelFMeasure;
        end
        
        average_TP = mean(TP_images);
        average_FP = mean(FP_images);
        average_FN = mean(FN_images);
        
        % Precision_images(isnan(Precision_images))=0;
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
else
    metrix_method = [];
end
end

