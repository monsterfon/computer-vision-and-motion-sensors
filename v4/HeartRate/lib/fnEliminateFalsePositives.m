function bbox = fnEliminateFalsePositives(bbox, trsh)

S = size(bbox);
for i = S(1):-1:1
    if bbox(i,3) < trsh
        bbox(i,:) = [];
    end
end
