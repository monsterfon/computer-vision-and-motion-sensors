function dataWin = fnWindowZeroCrossing(data)

L       = length(data);
data1   = data(1,:);

for i = 2:1000
    if sign(data(i,2)) ~= sign(data1(2))
        k1 = i;
        break
    end
end

for i = L:-1:L-1000
    if sign(data(i,2)) ~= sign(data1(2))
        for j = i:-1:i-1000
            if sign(data(j,2)) == sign(data1(2))
                kend = j;
                break
            end               
        end            
        break
    end
end

dataWin = data(k1:kend,:);



