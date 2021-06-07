Hello--before you use eegpipeline_v2.m, be sure to check these few things:

(1) you are using EEG taken using a standard 20-10 system
(2) the data format is .EDF
(3) the channel conventions in the rereference.m function are correct

When you wish to save the output of the pipeline, 
(1) un-comment the save function in line 74
(2) replace 'patientID' with a relevant identifier
(3) run the pipeline
(4) comment out the save function in line 74


