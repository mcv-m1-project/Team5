function newWindowProps=discard_CCL_regions(windowProps, tp)
%Discard regions depending on: the filling ratio, the form factor
%tp is the struct that contains the training set parameters
w = arrayfun(@(x) x.BoundingBox(3), windowProps);
h = arrayfun(@(x) x.BoundingBox(4), windowProps);

area=w.*h;
fr=[windowProps(:).FilledArea]'./(area);%Filling ratio
ff=w./h;%Form factor

%Threshold 1
% newWindowProps = windowProps((fr > tp.minfr - tp.stdfr)&(fr < tp.maxfr + tp.stdfr)...
%     &(ff > tp.minff - tp.stdfr)&(ff < tp.maxff + tp.stdff));
%Threshold 2
% newWindowProps = windowProps((fr > tp.minfr - tp.stdfr)&(fr < tp.maxfr + tp.stdfr)...
%     &(ff > tp.minff - tp.stdfr)&(ff < tp.maxff + tp.stdff)&(area > tp.minarea)&(area < tp.maxarea));
%Threshold 3
% newWindowProps = windowProps((fr > tp.minfr)&(fr < tp.maxfr)...
%     &(ff > tp.minff)&(ff < tp.maxff));
%Threshold 4
% newWindowProps = windowProps((fr > tp.minfr)&(fr < tp.maxfr)...
%     &(ff > tp.minff)&(ff < tp.maxff)&(area > tp.minarea)&(area < tp.maxarea));

%Threshold 5
newWindowProps = windowProps((fr > tp.meanfr - 3*tp.stdfr)&(fr < tp.meanfr + 3*tp.stdfr)...
    &(ff > tp.meanff - 3*tp.stdff)&(ff < tp.meanff + 3*tp.stdff)&(area > tp.minarea)&(area < tp.maxarea));

% params = struct('maxff', maxff, 'minff', minff, 'stdff', stdff,...
%     'maxfr', maxfr, 'minfr', minfr, 'stdfr', stdfr, 'maxarea', maxarea, ...
%     'minarea', minarea, 'meanff', meanff, 'meanfr', meanfr);
end