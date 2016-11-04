function params = trainSignCharacteristicsCCL(SC)
%Compute the range of accepted form factor and filling ratio values 
%based on the training set data
%SC is the array that contains the characteristics of the training set
%signs

form_factor=[SC{:,3}];
filling_ratio=[SC{:,4}];
BB_area=[SC{:,2}];

stdff=std(form_factor);
% maxff=max(form_factor)+stdff;
% minff=min(form_factor)-stdff;
maxff=max(form_factor);
minff=min(form_factor);
stdfr=std(filling_ratio);
maxfr=max(filling_ratio);
minfr=min(filling_ratio);
% maxfr=max(filling_ratio)+stdfr;
% minfr=min(filling_ratio)-stdfr;
maxarea=max(BB_area);
minarea=min(BB_area);

params = struct('maxff', maxff, 'minff', minff, 'stdff', stdff,...
    'maxfr',maxfr, 'minfr', minfr, 'stdfr', stdfr, 'maxarea', maxarea, 'minarea', minarea);




end