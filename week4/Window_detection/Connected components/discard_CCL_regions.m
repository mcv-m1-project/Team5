function newWindowProps=discard_CCL_regions(windowProps,tp)
%Discard regions depending on: the filling ratio, the form factor
%tp is the struct that contains the training set parameters
w = arrayfun(@(x) x.BoundingBox(3), windowProps);
h = arrayfun(@(x) x.BoundingBox(4), windowProps);
fr=[windowProps(:).FilledArea]'./(w.*h);%Filling ratio
ff=w./h;%Form factor

%Threshold 1
newWindowProps = windowProps((fr > tp.minfr - tp.stdfr)&(fr < tp.maxfr + tp.stdfr)...
    &(ff > tp.minff - tp.stdfr)&(ff < tp.maxff + tp.stdff));
end