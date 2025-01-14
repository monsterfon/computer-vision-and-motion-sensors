function RGBData = fnGetRGBROIMean(videoFrame, bbox)

RGBData = sum(sum(videoFrame(bbox(2):bbox(2)+bbox(4)-1,bbox(1):bbox(1)+bbox(3)-1,:),1),2)/(bbox(3))/(bbox(4));
