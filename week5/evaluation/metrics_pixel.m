function metrix_method = metrics_pixel(path,directory)

    files=dir(strcat(path,'/*.png'));

    num_files = size(files, 1);
    List_of_images =  files;

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
        pixelAnnotation = imread(strcat(directory, '/mask/mask.', List_of_images(i).name(1:end-9),'.png'));

        pixelCandidates = imread(strcat(path,filesep, char(List_of_images(i).name)));

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

    metrix_method = [average_Precision; average_Accuracy; average_sensitivity; average_FMeasure];% average_Specificit];
    metrix_method = [metrix_method; average_TP; average_FP; average_FN];% average_TN; average_time];

end