function [segments,storage] = rejection(data,rejbins,calcbins,F,Z,feats,amp);
%{
Inputs:
    data: filtered, montaged data with each row a column and channel a
    sample
    rejbins: length of rejection bins, in s
    calcbins: length of bins for calculations, in s
    F: sampling frequency in Hz
    Z: z score thresholding
    feats: number of features, keep set at 2 until additional features are
    included
    amp: amplitude threshold in uV
Outputs:
    segments: a cell matrix containing data segments for qEEG calculations,
    each row of each cell is a channel and each column of each cell is a
    sample
    storage: index boundaries for each usable segment for calculations
%}

lengthofsample = size(data,2);
rejbinsize = F*rejbins;

% index to the data segment
i = 1;
% index to the RMS matrix
a = 1;
while i <= lengthofsample-0.5
    % generate a second index to define a window over which to calculate
    % RMS
    i2 = i+rejbinsize;
    if i2 > lengthofsample
        % ensure that i2 is within the range of the sample length
        i2 = lengthofsample;
    end
    % calculate RMS and LL for all channels in each montage
    qqqqq = abs(data(:,i:i2)) > amp;
    qqqqq = sum(sum(qqqqq)) > 0;
    if qqqqq == 1
        RMS(:,a) = NaN *ones(size(data,1),1);
        LL(:,a) = NaN*ones(size(data,1),1);
    else
        RMS(:,a) = rms(data(:,i:i2),2);
        LL(:,a) = sum(abs(data(:,i+1:i2)-data(:,i:i2-1)),2);
    end

    % advance the RMS index by 1
    a = a + 1;
    % advance the sample index to the first index of the next overlapping 0.5 s segment
    i = i2;
end

bins = size(RMS,2);

%threshold setting
threshold_RMS = (mean(RMS','omitnan')+Z*(std(RMS','omitnan')))';
threshold_LL = (mean(LL','omitnan')+Z*(std(LL','omitnan')))';
threshold_RMS= threshold_RMS .* ones(size(RMS));
threshold_LL = threshold_LL .* ones(size(LL));


RMS_good = 1* (RMS < threshold_RMS);
sum_RMS = sum(RMS_good);

LL_good = 1* (LL< threshold_LL);
sum_LL = sum(LL_good);

everythingsummed = sum_RMS + sum_LL;
the_good_criterion = feats*size(data,1);

idx_good = find(everythingsummed==the_good_criterion);

i = 1;
%index with reference to usable 4 second segments
a = 1;
%stores the indices with reference to the 4 second segments
storage = [];

% finding good continuous segments
while i < bins
    i2 = i + (calcbins/(rejbinsize/F)-1);
    mat = [i:1:i2];
    isit = all(ismember(mat,idx_good));
    if isit == 0 
        i = i + 1;
        clear mat
    else 
        storage(a,:) = [i i2]; 
        a = a + 1; 
        i = i + (4/(rejbinsize/F)); 
    end
end

%extracting the segments
segments = {};
for i = 1:size(storage,1) 
    idx1 = rejbinsize*(storage(i,1)-1)+1; 
    idx2 = rejbinsize*(storage(i,2)); 
    segments{i} = data(:,idx1:idx2); 
end

end
