% function fnHeartRate(videoFileIn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% heart rate measurement  %%%%%%%%%%
%%%%             main function            %%%%
%%%%       includes video reading,        %%%%
%%%%     eye detection, ROI averaging,    %%%%  
%%%%       rgb signals normalization,     %%%%
%%%%      filtering and HR estimation.    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('lib')
load GlobalVariables.mat
HR = []; conf = []; RGBData = [];
videoFileIn = 'nov_pos.mp4';

%% read video data
tic
try
    [RGBData, errCode] = fnGetHRRGB(videoFileIn, GV);
    %% calculate heart rate

    if ~isempty(RGBData)
        if GV.Debug
            matFileOut = strcat(fnGetFileNameNoExt(videoFileIn), '.mat');
            save(strcat(GV.OutputMatDataPath,matFileOut), 'RGBData');
        end
       % [HR, conf] = fnEstimateHeartRate(RGBData, GV);
       ROI_k = 1; %% choose value between 1-3
       RGBDataTemp = squeeze(RGBData(:,ROI_k,:)); 
       [k, HR, HRW, PHR, PHRW, SNR, SNRW] = fnGetHeartRate(RGBDataTemp, videoFileIn, GV);
    end
catch
    errCode = 9;
end

if isempty(HR)
    fprintf(1,'%s\n',strcat(videoFileIn, ', ', num2str(round(toc)), ', ', num2str(errCode), ',null'));
else
    fprintf(1,'%s\n',strcat(videoFileIn, ', ', num2str(round(toc)), ', ', num2str(errCode), ', ', num2str(round(HR)), ', ', num2str(round(conf))));
end


