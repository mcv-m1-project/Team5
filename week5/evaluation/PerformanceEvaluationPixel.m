function [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity,pixelFMeasure] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN)
    % PerformanceEvaluationPixel
    % Function to compute different performance indicators (Precision, accuracy, 
    % specificity, sensitivity) at the pixel level
    %
    % [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'pixelTP'           Number of True  Positive pixels
    %    'pixelFP'           Number of False Positive pixels
    %    'pixelFN'           Number of False Negative pixels
    %    'pixelTN'           Number of True  Negative pixels
    %
    % The function returns the precision, accuracy, specificity and sensitivity

    pixelPrecision = pixelTP / (pixelTP+pixelFP);
    pixelPrecision(isnan(pixelPrecision)) = 0;
    pixelAccuracy = (pixelTP+pixelTN) / (pixelTP+pixelFP+pixelFN+pixelTN);
    pixelSpecificity = pixelTN / (pixelTN+pixelFP);%True Negative Rate
    pixelSensitivity = pixelTP / (pixelTP+pixelFN);
    pixelFMeasure = (2*pixelPrecision*pixelSensitivity)/(pixelPrecision+pixelSensitivity);
    pixelFMeasure(isnan(pixelFMeasure)) = 0;
end
