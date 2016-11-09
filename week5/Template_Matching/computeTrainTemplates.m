function templates = computeTrainTemplates(writing_dir, train_images_dir)
%Create and save mean grayscale image for each sign group using the 
%training set images.
%   templates: cell containing each template as an element

    load('../Results/week_01/Sign_characteristics_train');

    templates=cell(4,1);
    G={'CDE','F','A','B'};%Groups
    for i=1:length(G)
        indexs=zeros(length(SC_train),1);
        for j=1:length(G{i})
            indexsj=not(cellfun('isempty', strfind(SC_train(:,5), G{i}(j))));
            indexs=indexs|indexsj;
        end
        SC_group=SC_train(indexs,:);
        meanModel = ComputeMeanGrayImageForSignGroup(SC_group,train_images_dir);
        imwrite(meanModel,strcat(writing_dir,filesep,'Template',int2str(i),'.png'));
        templates{i}=meanModel;
        %figure();imshow(meanModel);
    end
end