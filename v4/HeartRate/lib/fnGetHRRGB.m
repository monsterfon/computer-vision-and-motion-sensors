function [RGBData, errCode] = fnGetHRRGB(videoFileIn, GV)

inputVideoFile   = strcat(GV.InputVideosPath, videoFileIn);
outputVideoFile  = strcat(GV.OutputVideosPath, videoFileIn);

videoFileReader  = VideoReader(inputVideoFile);
videoFrames      = read(videoFileReader); 
clear videoFileReader
videoFrames      = videoFrames(:,:,:,GV.Nstart:GV.NStep:end);

s  = size(videoFrames);
%% generate rotated videos
for i = 1:s(4)
    videoFramesNew(:,:,:,i) = imrotate(videoFrames(:,:,:,i),90);
end
videoFrames = videoFramesNew;
videoFrame  = imrotate(videoFrames(:,:,:,1),-90);


%% check orientation!!!
% if s(1) < s(2)
%     for i = 1:s(4)
%         videoFramesNew(:,:,:,i) = imrotate(videoFrames(:,:,:,i),-90);
%     end
%     videoFrames = videoFramesNew;
% end
% videoFrame       = videoFrames(:,:,:,1);

GV.s = size(videoFrames);
if GV.TrackEyesBig
    faceDetector = vision.CascadeObjectDetector('EyePairBig');
else
    faceDetector = vision.CascadeObjectDetector();
end

bbox          = step(faceDetector, videoFrame);
bbox          = fnEliminateFalsePositives(bbox, GV.BBoxMinSize);

RGBData       = [];
errCode       = 0; 
GV.breakN     = [];

if isempty(bbox)
    errCode      = 1;
else
    bbox            = fnResizeHead2Face(bbox);
    GV.bbox         = [bbox(2) GV.s(1)-bbox(1)-bbox(3) bbox(4) bbox(3)];
    GV.bbox2        = fnGetROIsV2(GV.bbox, GV);
    %GV.bbox2           = fnGetROIs(GV.bbox, GV);

    if GV.DebugInterPlot
        videoFrame       = videoFrames(:,:,:,1);
        videoFrame       = insertShape(videoFrame, 'Rectangle', GV.bbox, 'Color', 'y', 'LineWidth', 4);
        for i = 1:size(GV.bbox2,1)
            videoFrame   = insertShape(videoFrame, 'Rectangle', GV.bbox2, 'Color', 'm', 'LineWidth', 2);
        end
        figure; imshow(videoFrame); title('Heart rate measurement');
    end   
    if GV.Debug
        [RGBData, errCode, GV] = fnGetRGBROIVideoMean(videoFrames, GV, [], outputVideoFile);
    else
        [RGBData, errCode, GV] = fnGetRGBROIVideoMean(videoFrames, GV, []);
    end
end

if ~isempty(GV.breakN)
    errCode = 2;
    GV.breakN = [1 GV.breakN size(RGBData,1)];
    p = GV.breakN(2:end)-GV.breakN(1:end-1);
    k = find(p==max(p));
    RGBData = RGBData(GV.breakN(k):GV.breakN(k+1),:,:);
end

clear videoFileReader
