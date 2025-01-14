function [A, AW] = fnDTFTROI(RGBROI, GV)

s = size(RGBROI);
%% windowing
w          = hamming(s(1)); 
W          = w*ones(1,s(2));
RGBROIw    = RGBROI.*W;
%% DTFT
A          = fnDTFT(RGBROI, GV.omega); 
AW         = fnDTFT(RGBROIw, GV.omega); 

