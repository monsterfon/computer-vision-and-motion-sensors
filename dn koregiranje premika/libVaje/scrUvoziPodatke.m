data = zyxRotacija;
s = size(data);
for i = 1:s(1)
    x = regexp(data{i,3}, ',', 'split');
    tacc(i) = str2num(x(3));
    acc(i,1) = str2num(x(4));
    acc(i,2) = str2num(x(5));
    acc(i,3) = str2num(x(6));
    tom(i) = str2num(x(7));
    om(i,1) = str2num(x(8));
    om(i,2) = str2num(x(9));
    om(i,3) = str2num(x(10));
end
    
