function bboxPar = fnGetBboxRelParams(bbox, TrackEyesBig, Forehead, LeftCheek, RightCheek)

%% enable multiple ROIs!!

bboxPar = [];
if TrackEyesBig
    if RightCheek
        % bbox2WidthX     = round(bbox(1,3)/4); 
        % bbox2WidthY     = round(bbox(1,4)/3); 
        % bbox2OffsetY    = 20; 
        % bbox2OffsetX    = 0;
        % bboxPar = [bboxPar; bbox2WidthX bbox2WidthY bbox2OffsetX bbox2OffsetY];
    end
    if LeftCheek
        % bbox2WidthX     = round(bbox(1,3)/4); 
        % bbox2WidthY     = round(bbox(1,4)/3); 
        % bbox2OffsetY    = 10;
        % bbox2OffsetX    = bbox(1,3)-bbox2WidthX-10;
        % bboxPar = [bboxPar; bbox2WidthX bbox2WidthY bbox2OffsetX bbox2OffsetY];
    end
    if Forehead
        bbox2WidthX     = round(bbox(1,3)/4); 
        bbox2WidthY     = round(bbox(1,4)/2); 
        bbox2OffsetY    = -bbox(4)-40-bbox2WidthY;
        bbox2OffsetX    = round(bbox(1,3)/3)+10;
        bboxPar         = [bboxPar; bbox2WidthX bbox2WidthY bbox2OffsetX bbox2OffsetY];
    end
else
    if RightCheek
        bbox2WidthX     = round(bbox(1,3)/5); 
        bbox2WidthY     = round(bbox(1,4)/6); 
        bbox2OffsetY    = -round(bbox(1,4)*1.5/6);
        bbox2OffsetX    = round(bbox(1,3)/10);
        bboxPar = [bboxPar; bbox2WidthX bbox2WidthY bbox2OffsetX bbox2OffsetY];
    end
    if LeftCheek
        bbox2WidthX     = round(bbox(1,3)/5); 
        bbox2WidthY     = round(bbox(1,4)/6); 
        bbox2OffsetY    = -round(bbox(1,4)*1.5/6);
        bbox2OffsetX    = bbox(1,3)-bbox2WidthX-round(bbox(1,3)/10);
        bboxPar = [bboxPar; bbox2WidthX bbox2WidthY bbox2OffsetX bbox2OffsetY];
    end
    if Forehead
    % forehead from full head
        bbox2WidthX     = round(bbox(1,3)/3); 
        bbox2WidthY     = round(bbox(1,4)/5); 
        bbox2OffsetY    = -bbox(1,4);
        bbox2OffsetX    = bbox2WidthX;
        bboxPar         = [bboxPar; bbox2WidthX bbox2WidthY bbox2OffsetX bbox2OffsetY];
    end
end


