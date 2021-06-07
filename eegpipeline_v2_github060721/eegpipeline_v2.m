clear all;clc

% Import data and extract sampling frequency
[info,eeg] = edfread('patientID'); % import data
Fs = info.frequency(1,1); % extract the sampling frequency
ecg = []; % extract the ECG trace

% Cutting some data

% Rereference the data
[bipolar_montage,bipolar_labels,laplacian_montage,laplacian_labels] = rereference_scheme1(eeg);

% Filter the data
[filted_bipolar,filted_laplacian,filted_ecg] = filtermyeeg(bipolar_montage,laplacian_montage,ecg,Fs);

% Extract good segments of data for calculations
rejection_bin_ins = 0.5; % size of rejection bin in s
calculation_bin_ins = 4; % size of calculation bin in s
amplitude_rejection = 500; % threshold of amplitude-based rejection
z_set = 2; % standard deviation set for RMS/LL
features = 2; % number of features we are using (2, RMS and LL)

[bipolar_segments_for_calcs,bipolar_storage] = rejection(filted_bipolar,...
       rejection_bin_ins,calculation_bin_ins,Fs,z_set,features,amplitude_rejection);
[laplacian_segments_for_calcs,laplacian_storage] = rejection(filted_laplacian,...
    rejection_bin_ins,calculation_bin_ins,Fs,z_set,features,amplitude_rejection);

% Quantitative EEG
% Amplitude-based calculations
[bipolar_amp_calcs] = amplitude_params(bipolar_segments_for_calcs);
[laplacian_amp_calcs] = amplitude_params(laplacian_segments_for_calcs);

% Power spectral-based calculations
[bipolar_power_calcs] = power_params(bipolar_segments_for_calcs,Fs);
[laplacian_power_calcs] = power_params(laplacian_segments_for_calcs,Fs);

total_min_in_record = size(filted_bipolar,2)/(60*Fs);

total_min_kept_bipolar = size(bipolar_storage,1)*calculation_bin_ins/60;
total_min_reject_bipolar =  total_min_in_record - total_min_kept_bipolar;

total_min_kept_laplacian =  size(laplacian_storage,1)*calculation_bin_ins/60;
total_min_reject_laplacian =  total_min_in_record - total_min_kept_laplacian;

% Plotting 
% Kept segments will be plotted in black, rejected segments will be plotted
% in red
data_offset = 300; % offset for each trace
label_offset = 200; % offset for each label
ecgscale = 0.1; % scale factor for the ECG trace
plot_goodandbad(filted_bipolar,bipolar_labels,bipolar_segments_for_calcs,...
    bipolar_storage,rejection_bin_ins,calculation_bin_ins,data_offset,label_offset,...
    filted_ecg,ecgscale,Fs)
plot_goodandbad(filted_laplacian,laplacian_labels,laplacian_segments_for_calcs,...
    laplacian_storage,rejection_bin_ins,calculation_bin_ins,data_offset,label_offset,...
    filted_ecg,ecgscale,Fs)


% Assembling all Quantitative EEG calculations into a saveable object
patient.bipolar_amp = bipolar_amp_calcs;
patient.bipolar_power = bipolar_power_calcs;
patient.laplacian_amp = laplacian_amp_calcs;
patient.laplacian_power = laplacian_power_calcs;
patient.storage_bipolar = bipolar_storage;
patient.storage_laplacian = laplacian_storage;
patient.bipolar_channels = bipolar_labels;
patient.laplacian_channels = laplacian_labels;
patient.Fs = Fs;
patient.total_min = total_min_in_record;
patient.total_min_bp = total_min_kept_bipolar;
patient.total_min_lap = total_min_kept_laplacian;


% save('patientID','patient')

