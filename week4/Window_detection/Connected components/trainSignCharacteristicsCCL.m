function params = trainSignCharacteristicsCCL(SC)
%Compute the range of accepted form factor and filling ratio values 
%based on the training set data
%SC is the array that contains the characteristics of the training set
%signs

form_factor=[SC{:,3}];
filling_ratio=[SC{:,4}];
BB_area=[SC{:,2}];

stdff=std(form_factor);
stdfr=std(filling_ratio);


%Threshold 1
maxff=max(form_factor)+stdff;
minff=min(form_factor)-stdff;
maxfr=max(filling_ratio)+stdfr;
minfr=min(filling_ratio)-stdfr;
maxarea=max(BB_area);
minarea=min(BB_area);


%Threshold 2
% maxff=max(form_factor);
% minff=min(form_factor);
% maxfr=max(filling_ratio);
% minfr=min(filling_ratio);



params = struct('maxff', maxff,'minff',minff,'maxfr',maxfr,'minfr',minfr,'maxarea',maxarea,'minarea',minarea);

end