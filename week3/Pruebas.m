launch_task2_w3


files = files(1:5);


%%
[ Characteristics ] = trainSC_Window( SC_train );
metrix_methods = zeros(7, 2);
for i = 1:1
    params.colorSpace = colorSp(i);
    metrix = SignDetectionSlideWindow( params, files, Characteristics );
    if ~isempty(metrix)
        metrix_methods(:, i) = metrix;
    end
end
%%
params.directory_read_mask = strcat(params.directory_read_mask, '/HSV/');
params.directory_write_results = strcat(params.directory_write_results, '/HSV_SW/');
image_name = char(files(1).name);
Mask = imread(strcat(params.directory_read_mask, image_name,'_morf.jpg'));
[windowAnnotation, ~] = LoadAnnotations(strcat(params.directory_read_BBox, 'gt.', image_name, '.txt'));
load(strcat(params.directory_write_results, image_name, '_boxes.mat'));
Mask2 = Mask;

%%
Mask(round(windowAnnotation(1).y):round(windowAnnotation(1).y) + round(windowAnnotation(1).h),...
    round(windowAnnotation(1).x):round(windowAnnotation(1).x) + round(windowAnnotation(1).w)) = 128;
figure,imshow(Mask)
% Mask2(windowCandidates(1).y:windowCandidates(1).y + windowCandidates(1).h,...
%     windowCandidates(1).x:windowCandidates(1).x + windowCandidates(1).w) = 128;
% Mask2(windowCandidates(2).y:windowCandidates(2).y + windowCandidates(2).h,...
%     windowCandidates(2).x:windowCandidates(2).x + windowCandidates(2).w) = 128;
% figure,imshow(Mask2)