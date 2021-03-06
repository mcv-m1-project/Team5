% ------------------------------------------------------------------------ 
%  Copyright (C)
%  Universitat Politecnica de Catalunya BarcelonaTech (UPC) - Spain
%  University of California Berkeley (UCB) - USA
% 
%  Jordi Pont-Tuset <jordi.pont@upc.edu>
%  Pablo Arbelaez <arbelaez@berkeley.edu>
%  June 2014
% ------------------------------------------------------------------------ 
% This file is part of the MCG package presented in:
%    Arbelaez P, Pont-Tuset J, Barron J, Marques F, Malik J,
%    "Multiscale Combinatorial Grouping,"
%    Computer Vision and Pattern Recognition (CVPR) 2014.
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------
% Adapt the paths to the place where you have downloaded PASCAL and BSDS.
% In the case of BSDS500, you should put all images and ground truths 
% into the same folder, discarding the "val", "test", "train" folders
% ------------------------------------------------------------------------
function db_root_dir = database_root_dir( database )
if strcmp(database,'pascal2012')
    db_root_dir = '/Users/lidiatalavera/Desktop/icv-m1-2016-master/segment-ucm/MCG-PreTrained/datasets/pascal2012';
elseif strcmp(database,'bsds500')
    db_root_dir = '/Users/lidiatalavera/Desktop/icv-m1-2016-master/segment-ucm/MCG-PreTrained/datasets/bsds500';
else
    error(['Unknown database: ' database]);
end

end

