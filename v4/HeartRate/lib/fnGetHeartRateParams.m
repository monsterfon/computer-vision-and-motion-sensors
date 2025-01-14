function [k, HR, AHRSingle, PHRSingle, HRSNR] = fnGetHeartRateParams(A, f, GV)

k            = find(A(:,GV.colorChannel)==max(A(:,GV.colorChannel)));
HR           = f(k); 
AHRSingle    = A(k,:); 
PHRSingle    = A(k,:).^2; 
%PHRBand      = sum((A(k-GV.HRBandDeltaK:k+GV.HRBandDeltaK,:)).^2);

kNoise      = round(k*3/2);
deltaKNoise = round(k/6); 
% PNoise      = mean(A(kNoise-deltaKNoise:kNoise+deltaKNoise,:).^2);
PNoise = 0; HRSNR = 0;
% HRSNR       = 10*log10(PHRSingle./PNoise);