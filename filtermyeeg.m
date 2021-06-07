function [filtbi,filtlap,ecg] = filtermyeeg(X,Y,Z,F)
%{
Applies a 1-70 Hz bandpass filter (2nd order butterworth) and a 60 Hz
notch filter (2nd order butterworth) to the data
Inputs:
    X: unfiltered bipolar montage
    Y: unfiltered laplacian montage
    Z: raw ecg trace
    F: sampling frequency in Hz
Outputs:
    filtbi: filtered bipolar montage
    filtlap: filtered laplacian montage
    ecg: filtered ECG trace
%}

% 1 - 70 Hz bandpass filter
[b,a] = butter(2,[1 70]/(F/2),'bandpass');
% 60 Hz notch filter
[b2,a2] = butter(2,[59.5 60.5]/(F/2),'stop');

% filter all the bipolar montage
for i = 1:size(X,1)
    % bandpass
    Bipolar_filt1 = filtfilt(b,a,X(i,:)');
    % notch
    filtbi(i,:) = filtfilt(b2,a2,Bipolar_filt1)';
    clear Bipolar_filt1
end

if isempty(Z)
    ecg = [];
else
    cardio1 = filtfilt(b,a,Z');
    ecg = filtfilt(b2,a2,cardio1);
end


% filter all the laplacian montage
for i = 1:size(Y,1)
    % bandpass
    Laplacian_filt1 = filtfilt(b,a,Y(i,:)');
    % notch
    filtlap(i,:) = filtfilt(b2,a2,Laplacian_filt1)';
    clear Laplacian_filt1
end

end