%Task 1 w4
clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%
directory_templates = '../Results/week_04/Templates';
directory_train_images='../Images/train';
directory_write_results='../Results/week_04/validate_result';
if ~exist(directory_templates, 'dir')
  mkdir(directory_templates);
end
%%%%%%%%%%%%%%%%%%%%%%%


templates = computeTrainTemplates(directory_templates,directory_train_images);


load('../Results/week_01/names_files_train', 'files_train');        
load('../Results/week_01/names_files_validate', 'files_validate'); 
files = files_validate;
%files = files_train;


%Global approach
corr_threshold=.6;
run_TM_Correlation_Global(templates,directory_write_results,directory_train_images,files,corr_threshold);



%CCL
corr_threshold=.65;
dir_w3_results='../Results/week_03/validate_result';
CCL_method='HSV_CCL';
run_TM_Correlation_CCL(templates,directory_write_results,directory_train_images,files,corr_threshold,dir_w3_results,CCL_method);
CCL_method='HSV&RGB_CCL';
run_TM_Correlation_CCL(templates,directory_write_results,directory_train_images,files,corr_threshold,dir_w3_results,CCL_method);