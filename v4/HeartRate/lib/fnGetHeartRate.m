function [k, HR, HRW, PHR, PHRW, SNR, SNRW] = fnGetHeartRate(RGBData, videoFileIn, GV)

%% calculate heart rate without padding
RGBData_norm            = fnNormalizeData(RGBData,0,0);
RGBData_norm_filt       = fnFir(RGBData_norm, [GV.fFirMin GV.fFirMax]/GV.fsDeafult*2, GV.Nfir);
%RGBData_norm_filt       = fnWindowZeroCrossing(RGBData_norm_filt(GV.FilteredDataOffset:end,:));
%RGBData_norm_filt = fnWindowMax(RGBData_norm_filt(GV.FilteredDataOffset:end,:), fs);
% [AX, AXW, f]            = fn2DDTFTRGB(RGBData_norm_filt, GV, videoFileIn);
[AX, AXW, f]            = fnDTFTRGB(RGBData_norm, GV, videoFileIn);

[k, HR, ~, PHR, SNR]    = fnGetHeartRateParams(AX, f, GV);
[~, HRW, ~, PHRW, SNRW] = fnGetHeartRateParams(AXW, f, GV);




