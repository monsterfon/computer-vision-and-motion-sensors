%% write global variables 

GV.fsDeafult = 30;
GV.NStep     = 1;
GV.fFirMin    = 45/60; GV.fFirMax = 180/60; GV.Nfir = 30;
GV.HRResolution = 1;
GV.omDTFTMin = GV.fHRMin/30/GV.fsDeafult*pi;
GV.omDTFTMax = GV.fHRMax/30/GV.fsDeafult*pi;
%GV.DTFTNumOfPoints = (GV.fHRMax-GV.fHRMin)*GV.HRResolution; 
GV.DTFTNumOfPoints = 400;
GV.omega     = linspace(GV.omDTFTMin,GV.omDTFTMax,GV.DTFTNumOfPoints); 
GV.f         = GV.omega/2/pi*GV.fsDeafult*60;
%GV.DTFTFreqResolution = (GV.fDTFTMax-GV.fDTFTMin)/GV.fNumOfPoints;
GV.bitWin = 0;

%GV.colorChannel = 2;
GV.BBoxMinSize = 150;
GV.Nstart = 30;
GV.Nskip = 30;
GV.TrackEyesBig = 0;
GV.Forehead = 1;
GV.LeftCheek = 1;
GV.RightCheek = 1;
%GV.ReferenceROIYWidth = 100;
%GV.ReferenceROIYOffset = 200;
%GV.InputVideosPath = 'InputVideos/';
%GV.InputVideosPath = '';
GV.Debug = 1;
GV.DebugInterPlot = 1;
GV.plotColors = ['r';'g';'b'];

GV.InputVideosPath = 'InputVideos/';
% GV.InputVideosList = '/Users/saras/Dropbox (LKN)/SPECTA/Specta-Field/Specta-Field-Pending.csv';
% GV.ResultsList = '/Users/saras/Dropbox (LKN)/SPECTA/Specta-Field/Specta-Field-Results.csv';

GV.OutputVideosPath = 'OutputVideos/';
GV.OutputMatDataPath = 'HeartRateData/';

save('GlobalVariables.mat', 'GV')

%% errCodes:
%% 1 - no face detected in first frame
%% 2 - no face detected later in the analysis (lost face during tracking)
%% 9 - runtime error
