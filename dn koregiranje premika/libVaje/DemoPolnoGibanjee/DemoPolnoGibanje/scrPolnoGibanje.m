addpath('../libVaje')
clear all
DATA = readtable('gibanje.csv');

for i = 1:size(DATA,1)
    tempRow = DATA.Var3(i);
    data = split(tempRow, ',');
    t(i) = str2num(data{3});
    a(i,1) = -str2num(data{4});
    a(i,2) = -str2num(data{5});
    a(i,3) = -str2num(data{6});

    om(i,1) = str2num(data{8});
    om(i,2) = str2num(data{9});
    om(i,3) = str2num(data{10});
end

%% odstevanje odmika od stacionarnega stanja
%% ...

t = t - t(1);
deltaT = t(2:end) - t(1:end-1);
om_norm = sqrt(om(:,1).^2+om(:,2).^2+om(:,3).^2);
phi = om_norm(1:end-1).*deltaT';
v = om./om_norm;

st_stanje_zac = 1; st_stanje_kon = 1000;
g0 = mean(a(st_stanje_zac:st_stanje_kon,:))';
R = eye(3);

clear a_ref
for i = st_stanje_zac:st_stanje_kon   
    a_ref(:,i) = a(i,:)' - g0;
end
for i = st_stanje_kon:length(phi)
    R = R*fnRotacijskaMatrika(phi(i),v(i,:));
    a_ref(:,i) = R*a(i,:)' - g0;
end
a_ref = a_ref';

%% odstevanje lezenja
%% ... 

%% numericna integracija za pridobivanje poti in hitrosti
%% ...