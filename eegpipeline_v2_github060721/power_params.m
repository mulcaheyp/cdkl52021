function [output] = power_params(segmentsforcalc,F)
%{
Inputs:
segmentsforcalc: segments of data from a particular montage
F: sampling frequency in Hz

Outputs:
output is a matrix contianing power spectral parameters for the data
contained in segmentsforcalc

ROWS. For all columns and depths, the rows can be interpreted as follows:
[Delta Power;Theta Power;Alpha Power;Beta Power;1/f slope]

COLUMNS. Each column correponds to a channel. These channels are specified
when creating the montage matrices

DEPTH. Each entry in the third dimension represents an individual 
segment of data that the code has deemed to be usable. With many
segments, we thus have distributions of the power values for each channel
over the entire period of data collection. 

%}

spectrograms = {};
for i = 1:size(segmentsforcalc,2)
    allchannels = segmentsforcalc{i}';
    [pxx,freq] = periodogram(allchannels,[],[],F);
    spectrograms{i} = pxx;
    clear pxx
end

output = [];
for i = 1:size(spectrograms,2)
    allspectra = spectrograms{i};
    %normalization step?
    [bandz] = spectral1110(freq,allspectra,F);
    %1/f
    logtransform = log10(allspectra);
    logtransform = logtransform(freq>=2 & freq<=25,:);
    f_for_slope = freq(freq>=2 & freq<=25,:);
    for n = 1:size(logtransform,2)
        c = polyfit(f_for_slope,logtransform(:,n),1);
        slopes(1,n) = c(1);
        clear c;
    end
    output(1:4,:,i) = bandz;
    output(5,:,i) = slopes;
    clear bandz logtransform f_for_slope
end

end
