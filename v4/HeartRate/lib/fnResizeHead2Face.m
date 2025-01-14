function bbox = fnResizeHead2Face(bbox)

Dx   = round(bbox(3)/5); Dy = round(bbox(4)/10);
bbox = [bbox(1)+Dx, bbox(2)+Dy, bbox(3)-2*Dx, bbox(4)-4*Dy];

end