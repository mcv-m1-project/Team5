% Set-up UCM
cd MCG-PreTrained
install
cd ..

ima_name = '00.001460.jpg';
ima = imread(ima_name);

seg = segment_ucm(ima, 0.8);

imshow(label2color(seg));
imwrite(label2color(seg), '00.001460_seg.png');
Unique_img = unique(seg);

aux_img2=zeros(size(seg));
train_param = trainSignCharacteristicsCCL(SC_train);

for i=1:length(Unique_img)
    aux_img = seg==i;
    CC = bwconncomp(aux_img);
    windowProps=regionprops(CC,'All');
    windowProps=discard_CCL_regions(windowProps,train_param);%Discard BBs
    aux_img2 = aux_img|aux_img2;
end

figure,imshow(aux_img2)
% 
% for i=1:length(candidates.bboxes)
%    area = box_area( candidates.bboxes(i,:));
%     if area<maxi & area>mini
%             windowCandidates(end+1,:) = candidates.bboxes(i,:);
%     end
% end
% 
% hold on
% imshow(I)
% for j=1:length(windowCandidates)
% rectangle('Position',0.5*windowCandidates(j,:),'EdgeColor','g')
% hold off
% end


% hold on
% imshow(I)
% for j=1:length(windowCandidates)
%     
% x = windowCandidates(j,1);
% y = windowCandidates(j,2);
% width = windowCandidates(j,4)-windowCandidates(j,2);
% heigth = windowCandidates(j,3)-windowCandidates(j,1);
% 
% rectangle('Position',0.5.*[x,y,width,heigth],'EdgeColor','g')
% end
% hold off
% 

%   I = imread('00.000977.jpg');
% % I = imread('00.001146.jpg');
% %I = imread('00.001460.jpg');
% [candidates, ucm2] = im2mcg(I);
% mask = ucm2>0.84;
% imtool(mask)

% mask_h=imfill(mask,'holes');
% windowCandidates = candidates.bboxes;
% hold on
% imshow(mask)
% for j=1:length(windowCandidates)   
% x = windowCandidates(j,2);
% y = windowCandidates(j,1);
% heigth = windowCandidates(j,4)-windowCandidates(j,2);
% width = windowCandidates(j,3)-windowCandidates(j,1);
% 
% rectangle('Position',[x,y,width,heigth],'EdgeColor','g')
% end
% hold off

% hold on
% imshow(mask)
% x=112;
% y=898;
% heigth=1628-898;
% width=1171-112;
% rectangle('Position',[x,y,width,heigth],'EdgeColor','r')
% hold off


%candidates.bboxes(1,:)

