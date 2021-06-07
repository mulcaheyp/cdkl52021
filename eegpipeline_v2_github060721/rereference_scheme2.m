function [bipolar,blabels,laplacian,llabels] = rereference_scheme2(X)
%{
Inputs:
    X: the matrix containing the raw EEG data. Each row is a single channel
    and each column a sample
Outputs:
    bipolar: the bipolar montage. Each row represents a single channel and
    each column a sample
    blabels: a cell matrix containing the labels for each of the channels
    in the bipolar rereferenced scheme
    laplacian: the laplacian montage. Each row represents a single channel
    and each column a sample
    llabels: a cell matrix containing the labels for each of the channels
    in the laplacian rereferenced scheme
%}

%% Define channels
C3=X(10,:);
C4=X(18,:);
O1=X(8,:);
O2=X(24,:);
A1=X(2,:);
A2=X(26,:);
Cz=X(14,:);
F3=X(9,:);
F4=X(17,:);
F7=X(5,:);
F8=X(21,:);
Fz=X(13,:);
Fp1=X(4,:);
Fp2=X(20,:);
P3=X(11,:);
P4=X(19,:);
Pz=X(15,:);
T3=X(6,:);
T4=X(22,:);
T5=X(7,:);
T6=X(23,:);
    
%% Bipolar Montage
Fp1F3=F3-Fp1;
F3C3=C3-F3;
C3P3=P3-C3;
P3O1=O1-P3;
Fp2F4=F4-Fp2;
F4C4=C4-F4;
C4P4=P4-C4;
P4O2=O2-P4;
Fp1F7=F7-Fp1;
F7T3=T3-F7;
T3T5=T5-T3;
T5O1=O1-T5;
Fp2F8=F8-Fp2;
F8T4=T4-F8;
T4T6=T6-T4;
T6O2=O2-T6;
FzCz=Cz-Fz;
CzPz=Pz-Cz;

%store back into one matrix
bipolar = [Fp1F3;F3C3;C3P3;P3O1;Fp2F4;F4C4;C4P4;P4O2;Fp1F7;F7T3;T3T5;T5O1;Fp2F8;F8T4;T4T6;T6O2;FzCz;CzPz];
blabels = {'Fp1F3';'F3C3';'C3P3';'P3O1';'Fp2F4';'F4C4';'C4P4';'P4O2';'Fp1F7';'F7T3';'T3T5';'T5O1';'Fp2F8';'F8T4';'T4T6';'T6O2';'FzCz';'CzPz'};
   
%% LaPlacian Routine, unfiltered
Fp1lap=(((2.*Fp2)+F3+(2.*F7))/5)-Fp1;
F3lap=((F7+Fp1+Fz+C3)/4)-F3;
C3lap=((T3+F3+Cz+P3)/4)-C3;
P3lap=((C3+Pz+O2+T5)/4)-P3;
F7lap=(((2.*Fp1)+F3+(2.*T3))/5)-F7;
T3lap=(((2.*F7)+C3+(2.*T5))/5)-T3;
T5lap=(((2.*T3)+P3+(2.*O1))/5)-T5;
O1lap=((P3+(2.*O2)+(2.*T5))/5)-O1;
Fp2lap=(((2.*F8)+F4+(2.*Fp1))/5)-Fp2;
F4lap=((Fp2+F8+C4+Fz)/4)-F4;
C4lap=((F4+T4+P4+Cz)/4)-C4;
P4lap=((C4+T6+O2+Pz)/4)-P4;
F8lap=(((2.*Fp2)+(2.*T4)+F4)/5)-F8;
T4lap=(((2.*F8)+(2.*T6)+C4)/5)-T4;
T6lap=(((2.*T4)+(2.*O2)+P4)/5)-T6;
O2lap=((P4+(2.*T6)+(2.*O1))/5)-O2;
Fzlap=((Fp2+F4+Cz+F3+Fp1)/5)-Fz;
Czlap=((Fz+C4+Pz+C3)/4)-Cz;
Pzlap=((Cz+P4+O2+O1+P3)/5)-Pz;

% store back into one matrix
laplacian = [Fp1lap;F3lap;C3lap;P3lap;F7lap;T3lap;T5lap;O1lap;Fp2lap;F4lap;C4lap;P4lap;F8lap;T4lap;T6lap;O2lap;Fzlap;Czlap;Pzlap];
llabels = {'Fp1lap';'F3lap';'C3lap';'P3lap';'F7lap';'T3lap';'T5lap';'O1lap';'Fp2lap';'F4lap';'C4lap';'P4lap';'F8lap';'T4lap';'T6lap';'O2lap';'Fzlap';'Czlap';'Pzlap'};

end