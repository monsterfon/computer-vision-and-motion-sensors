function [xFiltDown, tDown] = fnFilterAndDownsample(x, fs, fsDown, nFilt, t)

if fsDown/fs*2 < 1
    xFilt = fnFir(x, fsDown/fs*2, nFilt, 0);
else 
    xFilt = x;
end
t = t(round(nFilt/2+1):end);
%t_IMU = (X(11:end,1)-X(11,1))/1000;
tDown = t(1,1):1/fsDown:t(end);
xFiltDown = interp1(t,xFilt(round(nFilt/2+1):end,:),tDown);
