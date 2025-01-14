function bbox2 = fnGetROIsV2(bbox, GV)

bbox2 = [];
if GV.RightCheek
    bbox2WidthX     = round(bbox(1,3)/5); 
    bbox2WidthY     = round(bbox(1,4)/6); 
    bbox2OffsetY    = bbox(1,4)-bbox2WidthY-round(bbox(1,4)/10);
    bbox2OffsetX    = bbox(1,3)-bbox2WidthX-round(bbox(1,3)/10);
%         bbox2           = [bbox2; bbox(1)+bbox2OffsetX, bbox(2)+bbox(4)+bbox2OffsetY, bbox2WidthX, bbox2WidthY]; 
    bbox2           = [bbox2; bbox(1)+bbox2OffsetX, bbox(2)+bbox2OffsetY, bbox2WidthY, bbox2WidthX]; 
end
if GV.LeftCheek
    bbox2WidthX     = round(bbox(1,3)/5); 
    bbox2WidthY     = round(bbox(1,4)/6); 
    bbox2OffsetY    = round(bbox(1,4)/10);
    bbox2OffsetX    = bbox(1,3)-bbox2WidthX-round(bbox(1,3)/10);
%         bbox2           = [bbox2; bbox(1)+bbox2OffsetX, bbox(2)+bbox(4)+bbox2OffsetY, bbox2WidthX, bbox2WidthY]; 
    bbox2           = [bbox2; bbox(1)+bbox2OffsetX, bbox(2)+bbox2OffsetY, bbox2WidthY, bbox2WidthX]; 
end
if GV.Forehead
    % forehead from full head
    bbox2WidthX     = round(bbox(1,3)/5); 
    bbox2WidthY     = round(bbox(1,4)/3); 
    bbox2           = [bbox2; bbox(1), bbox(2)+bbox2WidthY, bbox2WidthX, bbox2WidthY]; 
end
%% background
bbox2           = [bbox2; bbox(1), 1, bbox(3), 100]; 




