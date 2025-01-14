addpath('../lib')
addpath('../data')

accFileName      = "";
gyroFileName     = "";
QualisysFileName = "";
fs               = 50;

%% Uvoz IMU signalov
ACCDATA          = readtable(accFileName);
GYRODATA         = readtable(gyroFileName);
[acc, om, t, t0] = fnSyncAccOmMW(ACCDATA, GYRODATA, fs);

%% Uvoz Qualysis signalov
load(QualisysFileName);
temp = strsplit(QualisysFileName,'.');
qualisysStrctName = temp{1};
eval(strcat('Q = ', qualisysStrctName));
Q
sQls     = (squeeze(Q.RigidBodies.Positions(1,:,:)))';
RQlsLong = squeeze(Q.RigidBodies.Rotations(1,:,:));
NQ       = length(RQls);

j = 1;
for i=1:size(RQ,2)
    RQls(i,1:3,1:3) = [RQlsLong(1:3,i) RQlsLong(4:6,i) RQlsLong(7:9,i)];
end

RQ       = fnFilterAndDownsample(RQls', Q.FrameRate, 50, 20, (0:N-1)/Q.FrameRate);
[sQ, tQ] = fnFilterAndDownsample(sQls, Q.FrameRate, 50, 20, (0:N-1)/Q.FrameRate);

k = find(~isnan(sQ(:,1))); 
tValid          = zeros(length(tQ),1); tValid(k) = 1; tValid = tValid(1:end-1);
disp(['Qualisys loss: ', num2str(1-length(k)/length(RQ))]);

sQFin           = interp1(tQ(k),sQ(k,:),tQ(1:end-1));  
RQFin           = interp1(tQ(k),RQ(k,:),tQ(1:end-1));  tQ = tQ(1:end-1);

%% Izris signalov
fig = figure;
subplot(221), plot(acc)
xlabel('$n$', 'interpreter', 'latex'), ylabel('$acc\ [n]$', 'interpreter', 'latex')
subplot(222), plot(om)
xlabel('$n$', 'interpreter', 'latex'), ylabel('$\Omega\ [n]$', 'interpreter', 'latex')
subplot(223), plot(sQFin)
xlabel('$n$', 'interpreter', 'latex'), ylabel('$s\ [n]$', 'interpreter', 'latex')
subplot(224), plot(squeeze(RQFin(:,1,:)))
xlabel('$n$', 'interpreter', 'latex'), ylabel('$x\ [n]$', 'interpreter', 'latex')

x = ginput(2); x = round(x);
close(fig)

nStart         = x(1);
nEnd           = x(2);

omFin          = om(x(1):x(2));
accFin         = acc(x(1):x(2));

[~, OMFIN, ~]  = fnFFT(omFin);
[~, ACCFIN, ~] = fnFFT(accFin);
f              = linspace(0,fs,length(omFin));
figure;
subplot(121), plot(omFin)
xlabel('$n$', 'interpreter', 'latex'), ylabel('$om\ [n]$', 'interpreter', 'latex')
subplot(122), plot(accFin)
xlabel('$n$', 'interpreter', 'latex'), ylabel('$acc\ [n]$', 'interpreter', 'latex')
subplot(123), plot(OMFIN)
xlabel('$f$', 'interpreter', 'latex'), ylabel('$A_{om}\ (f)$', 'interpreter', 'latex')
subplot(124), plot(ACCFIN)
xlabel('$f$', 'interpreter', 'latex'), ylabel('$A_{acc}\ (f)$', 'interpreter', 'latex')

%% filtriranje
fco = ;
[b, a]  = butter(fs, fco/fs*2);
omFilt  = filtfilt(b,a,omFin);
accFilt = filtfilt(b,a,accFin);

%% izracun rotacije
g0      = mean(accFilt(1:100,:));

%% izracun rotacije vektorja g
%% rotacija za minus kot v referencnem sistemu
for i = 1:length(omFilt)-1
    v = omFilt(i,:);
    deltaT = t(i+1)-t(i);
    phi = -norm(v)*deltaT*180/pi;
    v = v/norm(v);    
    R = fnRotacijskaMatrika(phi,v);
    g(i+1,:) = (R*g(i,:)')';
end

figure;
subplot(121)
plot(accFilt)
hold on
plot(g, 'LineWidth', 1.2)
xlabel('$n$', 'interpreter', 'latex'), ylabel('$acc\ [n]$', 'interpreter', 'latex')
subplot(122)
plot(squeeze(RQFin(:,3,:)))
hold on
plot(g, 'LineWidth', 1.2)
xlabel('$n$', 'interpreter', 'latex'), ylabel('$x\ [n]$', 'interpreter', 'latex')

deltaN = ;

%% izracun pospeskov iz IMU
%% izracun pospeskov v globalnem koordinatnem sistemu
%% izracun hitrosti v globalnem koordinatnem sistemu
%% izracun poti v globalnem koordinatnem sistemu

%% uporaba komplementarnega filtra
%% uporaba Kalmanovega filtra


