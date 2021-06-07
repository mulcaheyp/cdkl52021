function [bands]= spectral1110(f, pxx, fs)
%pxx= power spectrum normalized to AUC for power spectrum for whole record
%f=frequencies of power spectrum in Hz
%bands= array to hold AUC of each of the frequency bands (delta, theta, alpha, beta, gamma, 50-100hz) from the normalized power spectrum

i=1;
while(i <(length(f)+1))
  if f(i)>=1 && f(i)<=4 %% find delta vector 0.1-4 Hz   
     delta(i,:)= pxx(i,:);
  end
  if f(i)>4 && f(i)<=8 %% find theta vector 4-8 Hz    
     theta(i,:)= pxx(i,:);
  end
 
  if f(i)>8 && f(i)<=13 %% find alpha vector 8-13Hz 
    alpha(i,:)= pxx(i,:);
  end
 
  if f(i)>13 && f(i)<=25 %% find beta vector 13.1-25Hz  
    beta(i,:)= pxx(i,:);
  end

 i=i+1;
end
% band power in delta/theta/alpha/beta
bands(1,:)=trapz(delta);
bands(2,:)=trapz(theta);
bands(3,:)=trapz(alpha);
bands(4,:)=trapz(beta);
end