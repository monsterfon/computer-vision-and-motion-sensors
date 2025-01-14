function bbox2 = fnGetROIs(bbox, GV)

%% enable multiple ROIs!!

bbox2 = [];
if GV.TrackEyesBig
    if GV.RightCheek
        % bbox2WidthX     = round(bbox(1,3)/4); 
        % bbox2WidthY     = round(bbox(1,4)/3); 
        % bbox2OffsetY    = 20; 
        % bbox2OffsetX    = 0;
        % bboxPar = [bboxPar; bbox2WidthX bbox2WidthY bbox2OffsetX bbox2OffsetY];
    end
    if GV.LeftCheek
        % bbox2WidthX     = round(bbox(1,3)/4); 
        % bbox2WidthY     = round(bbox(1,4)/3); 
        % bbox2OffsetY    = 10;
        % bbox2OffsetX    = bbox(1,3)-bbox2WidthX-10;
        % bboxPar = [bboxPar; bbox2WidthX bbox2WidthY bbox2OffsetX bbox2OffsetY];
    end
    if GV.Forehead
        bbox2WidthX     = round(bbox(1,3)/4); 
        bbox2WidthY     = round(bbox(1,4)/2); 
        bbox2OffsetY    = -bbox(4)-40-bbox2WidthY;
        bbox2OffsetX    = round(bbox(1,3)/3)+10;
        bbox2           = [bbox2; bbox(1)+bbox2OffsetX, bbox(2)+bbox(4)+bbox2OffsetY, bbox2WidthX, bbox2WidthY]; 
    end
else
    if GV.RightCheek
        bbox2WidthX     = round(bbox(1,3)/5); 
        bbox2WidthY     = round(bbox(1,4)/6); 
        bbox2OffsetY    = -round(bbox(1,4)*1.5/6);
        bbox2OffsetX    = round(bbox(1,3)/10);
        bbox2           = [bbox2; bbox(1)+bbox2OffsetX, bbox(2)+bbox(4)+bbox2OffsetY, bbox2WidthX, bbox2WidthY]; 
    end
    if GV.LeftCheek
        bbox2WidthX     = round(bbox(1,3)/5); 
        bbox2WidthY     = round(bbox(1,4)/6); 
        bbox2OffsetY    = -round(bbox(1,4)*1.5/6);
        bbox2OffsetX    = bbox(1,3)-bbox2WidthX-round(bbox(1,3)/10);
        bbox2           = [bbox2; bbox(1)+bbox2OffsetX, bbox(2)+bbox(4)+bbox2OffsetY, bbox2WidthX, bbox2WidthY]; 
   end
   if GV.Forehead
    % forehead from full head
        bbox2WidthX     = round(bbox(1,3)/3); 
        bbox2WidthY     = round(bbox(1,4)/5); 
        bbox2OffsetY    = -bbox(1,4);
        bbox2OffsetX    = bbox2WidthX;
        bbox2           = [bbox2; bbox(1)+bbox2OffsetX, bbox(2)+bbox(4)+bbox2OffsetY, bbox2WidthX, bbox2WidthY]; 
   end
   %% background ROI
   %bbox2     = [bbox2; 1 bbox(2)-GV.ReferenceROIYOffset XWidth GV.ReferenceROIYWidth];
%    bbox2     = [bbox2; 1 GV.bbox(2) GV.bbox(3)/2 GV.bbox(4)];
%    bbox2     = [bbox2; 1 GV.bbox(2) GV.bbox(3)/2 GV.bbox(4)];
end


