function plot_goodandbad(eeg,labels,segments,storage,rejbin,calcbin,doffset,loffset,ecgdata,ecgscale,F)
%{
This function plots an entire montage showing which segments have been
rejected and which segments have been used for qEEG calculations.
Inputs:
eeg: filtered data for a particular montage
labels: labels for the montage
segments: the segments used for calculations using a particular montage
storage: storage matrix containing indices for the segments of EEG used in
qEEG calculations
rejbins: size of bins used for thresholding procedure
calcbin: size of segment used for qEEG calculations
doffset: offset for each data trace
loffset: offset for each of the labels
ecgdata: ECG data trace
ecgscale: scaling parameter for the ECG data
F: sampling frequency in Hz
%}
rejbinsize = rejbin*F;

figure

for i = 1:size(eeg,1)
    %plot all the EEG data in red, with labels for the channels
    plot(1/F*[1:size(eeg,2)],eeg(i,:)-doffset*i,'r')
    txt = labels{i};
    text(1,loffset-doffset*i,txt);
    hold on
end

if isempty(ecgdata)
else
    plot(1/F*[1:size(eeg,2)],ecgscale.*ecgdata-doffset*(i+1),'b')
    text(1,loffset-doffset*(i+1),'ECG');
end

for i = 1:size(segments,2)
    %plot all the good EEG segments in black
    %go through the segments we extracted earlier
    SEGMENT = segments{i};
    %identify the first index of the segment
    initialindex = rejbinsize*(storage(i,1)-1) + 1;
    
    for ii = 1:size(SEGMENT,1)
        %plot
        plot(1/F*[initialindex:initialindex+calcbin*F-1],SEGMENT(ii,:)-doffset*ii,'k')
        hold on
    end

    clear initialindex
end



end