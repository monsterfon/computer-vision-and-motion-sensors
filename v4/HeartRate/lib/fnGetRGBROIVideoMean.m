function [RGBData, errCode, GV] = fnGetRGBROIVideoMean(videoFrames, GV, RGBDataIn, outputVideoFile)

videoFrame      = videoFrames(:,:,:,1);

%% save video result
if nargin == 4
    videoObject = VideoWriter(outputVideoFile, 'MPEG-4');
    open(videoObject)
end

s = size(videoFrames);
%RGBData = zeros(s(4), size(GV.bbox2,1)+1, 3);
RGBData = zeros(s(4), size(GV.bbox2,1), 3);

%% optical flow for bbox
bboxPoints      = bbox2points(GV.bbox(1, :));

points          = detectMinEigenFeatures(rgb2gray(videoFrame), 'ROI', GV.bbox);

pointTracker    = vision.PointTracker('MaxBidirectionalError', 2);
points          = points.Location;
initialize(pointTracker, points, videoFrame);
oldPoints       = points;   

errCode         = 0; 
bbox            = GV.bbox;

for n = 1:s(4)
    videoFrame        = videoFrames(:,:,:,n);
  
    [points, isFound] = step(pointTracker, videoFrame);
    visiblePoints     = points(isFound, :);
    oldInliers        = oldPoints(isFound, :);
    
    if size(visiblePoints, 1) >= 2         
        [xform, ~, visiblePoints] = estimateGeometricTransform(oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
        bboxPoints = round(transformPointsForward(xform, bboxPoints));
        bbox(1)    = bboxPoints(1,1);
        bbox(2)    = bboxPoints(1,2);
%       bbox       = [bboxPoints(1,1), bboxPoints(3,2), bboxPoints(2,1)-bboxPoints(1,1), bboxPoints(3,2)-bboxPoints(3,1)];
        
        if nargin == 4
            bboxPolygon = reshape(bboxPoints', 1, []);
            videoFrame  = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 2);
%             bbox2       = fnGetROIsV2(bbox, GV);
            bbox2       = fnGetROIsV2(bbox, GV);
            videoFrame  = insertShape(videoFrame, 'Rectangle', bbox2, 'Color', 'm', 'LineWidth', 2);
            videoFrame  = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'white');
            writeVideo(videoObject, videoFrame);
        end
        oldPoints   = visiblePoints;
        setPoints(pointTracker, oldPoints); 
    else
        errCode          = 2; 
        RGBData          = RGBData(1:n-1,:,:);
        GV.breakN        = [GV.breakN n];
        break;
    end
  
    %% average color chanels values  
%     bbox2       = fnGetROIsV2(bbox, GV);
    bbox2       = fnGetROIsV2(bbox, GV);
    for i = 1:size(bbox2,1)
        RGBData(n, i, :)  = fnGetRGBROIMean(videoFrame, bbox2(i,:));
    end
%     RGBData(n, i+1, :)    = fnGetRGBROIMean(videoFrame, [1 1 GV.s(2) GV.s(1)]);
%    RGBData(n, i+1, :)    = fnGetRGBROIMean(videoFrame, [1 1 GV.s(2) GV.s(1)]);
end

RGBData = cat(1, RGBDataIn, RGBData);

if errCode == 2
    n       = n + GV.Nskip;
    if n < s(4)
        videoFrame = imrotate(videoFrames(:,:,:,n),-90);
        if GV.TrackEyesBig
            faceDetector = vision.CascadeObjectDetector('EyePairBig');
        else
            faceDetector = vision.CascadeObjectDetector();
        end
        bbox             = step(faceDetector, videoFrame);
        bbox             = fnEliminateFalsePositives(bbox, GV.BBoxMinSize);
        bbox             = fnResizeHead2Face(bbox);
        GV.bbox          = [bbox(2) GV.s(1)-bbox(1)-bbox(3) bbox(4) bbox(3)];
        GV.bbox2         = fnGetROIsV2(GV.bbox, GV); 
        if GV.Debug
            [RGBData, errCode] = fnGetRGBROIVideoMean(videoFrames(:,:,:,n:end), GV, RGBData, outputVideoFile);
        else
            [RGBData, errCode] = fnGetRGBROIVideoMean(videoFrames(:,:,:,n:end), GV, RGBData);
        end
    end   
end

if nargin == 4
    close(videoObject)
end


