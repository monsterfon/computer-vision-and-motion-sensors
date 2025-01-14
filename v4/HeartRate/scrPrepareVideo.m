%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% merjenje srcnega utripa %%%%%%%%%%
%%%%%%%%%    skrajsanje posnetka    %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% videoFileReader = vision.VideoFileReader('/Users/saras/Desktop/Video3.mov');
videoFileReader = vision.VideoFileReader('InputVideos/nov_pos.mp4');

videoObject = VideoWriter('InputVideos/test');
videoFrame = step(videoFileReader); 
open(videoObject)
videoPlayer  = vision.VideoPlayer('Position',[100 100 [size(videoFrame, 2), size(videoFrame, 1)]]);
n = 1;
n_zac = 2*30;
n_kon = 640;

while ~isDone(videoFileReader)
    step(videoPlayer, videoFrame);
    if n > n_zac && n < n_kon
        writeVideo(videoObject, videoFrame); 
    end
    videoFrame = step(videoFileReader); 
    n = n+1;
end

release(videoFileReader);
release(videoPlayer);
close(videoObject);
