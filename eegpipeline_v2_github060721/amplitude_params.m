function [outputs] = amplitude_params(segments_for_calcs)
%{
Inputs: 
segments_for_calcs: segments of data from a particular montage
outputs: amplitude-related calculations for the EEG

Amplitude Parameters Matrices:
Row 1: Mean Amplitude
Row 2: Stdev Amplitude
Row 3: Skewness Amplitude
Row 4: Kurtosis Amplitude 

Columns: Each column corresponds to a channel. These channels are specified
when creating the montages.

DEPTH. Each entry in the third dimension represents an individual
segment of data that the code has deemed to be usable. With many 
segments, we thus have distributions of the power values for each channel
over the entire period of data collection. 

%}

outputs = [];

for i = 1:size(segments_for_calcs,2) %for all 4 second segments
    allchannels = segments_for_calcs{i}'; %Call up the 4 second segment of the montage
    mean_bp = mean(allchannels);
    std_bp = std(allchannels);
    skew_bp = skewness(allchannels);
    kurt_bp = kurtosis(allchannels);
    outputs(:,:,i) = [mean_bp;std_bp;skew_bp;kurt_bp];
    clear allchannels mean_bp std_bp skew_bp kurt_bp
end


end