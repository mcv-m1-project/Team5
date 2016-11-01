function params = trainSignCharacteristicsCCL(SC)
%Compute the range of accepted form factor and filling ratio values 
%based on the training set data
%SC is the array that contains the characteristics of the training set
%signs

form_factor=[SC{:,3}];
filling_ratio=[SC{:,4}];

stdff=std(form_factor);
maxff=max(form_factor)+stdff;
minff=min(form_factor)-stdff;
stdfr=std(filling_ratio);
maxfr=max(filling_ratio)+stdfr;
minfr=min(filling_ratio)-stdfr;

params = struct('maxff', maxff, 'minff', minff, 'maxfr',maxfr, 'minfr', minfr);
end