function bboxPoints = fnGetBbox(videoFrame, videoFrameRef, bboxRef)

bboxPoints = bbox2points(bboxRef(1, :));
points = detectSURFFeatures(rgb2gray(videoFrameRef), 'ROI', bboxRef);

pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
points = points.Location;
initialize(pointTracker, points, videoFrameRef);

oldPoints = points;

[points, isFound] = step(pointTracker, videoFrame);
visiblePoints = points(isFound, :);
oldInliers = oldPoints(isFound, :);
        
if size(visiblePoints, 1) >= 2         
    [xform, ~, visiblePoints] = estimateGeometricTransform(...
            oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);    
    bboxPoints = round(transformPointsForward(xform, bboxPoints));            
end
