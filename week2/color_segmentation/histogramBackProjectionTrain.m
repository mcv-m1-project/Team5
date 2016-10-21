function histogramBackProjectionTrain(nbins,directory_write,directory_read_train)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Computes and saves the 2D histogram for each group of signs using the
%   training dataset.
%
%   'nbins' Number of bins of the 2D histogram
%   'directory_write' Path of the results directory where the sign 
%       characteristics matrix has been saved
%   'directory_read_train' Path of the directory where the train images are
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    directory_write = strcat('./', directory_write);
    directory_read_train = strcat('./', directory_read_train);
    
    %Sign characteristics of the training set
    load(strcat(directory_write, '/Sign_characteristics_train'));

    %Group1: Types A,B,C
    index_A=not(cellfun('isempty', strfind(SC_train(:,5), 'A')));
    index_B=not(cellfun('isempty', strfind(SC_train(:,5), 'B')));
    index_C=not(cellfun('isempty', strfind(SC_train(:,5), 'C')));
    SC_group1=SC_train(index_A|index_B|index_C,:);

    %Group2: Types D,F
    index_D=not(cellfun('isempty', strfind(SC_train(:,5), 'D')));
    index_F=not(cellfun('isempty', strfind(SC_train(:,5), 'F')));
    SC_group2=SC_train(index_D|index_F,:);

    %Group3: Type E
    index_E=not(cellfun('isempty', strfind(SC_train(:,5), 'E')));
    SC_group3=SC_train(index_E,:);

    %Compute the histogram for each group:
    H2D_group1=groupHistogramHS(SC_group1,nbins,directory_read_train);
    H2D_group2=groupHistogramHS(SC_group2,nbins,directory_read_train);
    H2D_group3=groupHistogramHS(SC_group3,nbins,directory_read_train);
    
    %Save histograms
    save(strcat(directory_write, '/Histogram_2D_group1'), 'H2D_group1');
    save(strcat(directory_write, '/Histogram_2D_group2'), 'H2D_group2');
    save(strcat(directory_write, '/Histogram_2D_group3'), 'H2D_group3');

end