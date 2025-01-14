function [HR, conf] = fnEstimateHeartRateDebug(RGBData, GV, videoFileIn)
%RGBData = RGBData(20:end,:,:);
s = size(RGBData);
bitNorm = 0; %Nstart = 50; Nend = s(1)-2;
HR = []; conf = [];

fig = figure;
for i = 1:s(2)
    RGBDataTemp  = interp1((1:GV.NStep:s(1)*GV.NStep),squeeze(RGBData(:,i,:)),(1:s(1)));
    RGBData_norm = fnNormalizeData(RGBDataTemp,bitNorm,bitNorm);
    subplot(4,s(2)+5,i), hold on
    for j = 1:3, plot(RGBData_norm(:,j), 'Color', GV.plotColors(j)); end 
    varOut(i) = sum(var(squeeze(RGBData(:,i,:)))); 
    startStopDiff(i,:) = RGBData_norm(end,:) - RGBData_norm(1,:);

    [AX{i}, AXW{i}]            = fnDTFTROI(RGBData_norm, GV);
    AM{i} = AX{i}.*AXW{i};
    
    subplot(4,s(2)+5,i+s(2)+5), hold on
    for j = 1:3, plot(GV.f,AX{i}(:,j), 'Color', GV.plotColors(j)); end
    set(gca, 'XScale', 'log');

    subplot(4,s(2)+5,i+(s(2)+5)*2), hold on
    for j = 1:3, plot(GV.f,AXW{i}(:,j), 'Color', GV.plotColors(j)); end
    set(gca, 'XScale', 'log');
    
    subplot(4,s(2)+5,i+(s(2)+5)*3), hold on
    for j = 1:3, plot(GV.f, AM{i}(:,j), 'Color', GV.plotColors(j)); end
    set(gca, 'XScale', 'log'); 
end
sgtitle(videoFileIn(1:8));
startStopDiff
p = sum(abs(startStopDiff),2)
k = find(p(1:3)==min(p(1:3)))
kCand = find(AX{k}(:,2)==max(AX{k}(:,2))); 
kCandW = find(AXW{k}(:,2)==max(AXW{k}(:,2))); 
kCandM = find(AXW{k}(:,2)==max(AXW{k}(:,2))); 
[GV.f(kCand) GV.f(kCandW) GV.f(kCandM)]

% kTemp = find(AM{4}(:,3)==max(AM{4}(:,3))); 
% kTempInter = kTemp + find(AM{4}(kTemp+50:kTemp+120,3)==max(AM{4}(kTemp+50:kTemp+120,3))) - 1;
% r = AM{4}(kTemp,3)/AM{4}(kTempInter,3)

kTemp = find(AM{4}(:,3)==max(AM{4}(:,3))); 
kTempInter = kTemp + 50 + find(AM{4}(kTemp+50:kTemp+120,3)==max(AM{4}(kTemp+50:kTemp+120,3))) - 1;
r = AM{4}(kTemp,3)/AM{4}(kTempInter,3)

AH  = max(AX{4})*1.05-AX{4}; AH(:,1) = AH(:,1)/max(AH(:,1)); AH(:,2) = AH(:,2)/max(AH(:,2)); AH(:,3) = AH(:,3)/max(AH(:,3));
AHW = max(AXW{4})*1.05-AXW{4}; AHW(:,1) = AHW(:,1)/max(AHW(:,1)); AHW(:,2) = AHW(:,2)/max(AHW(:,2)); AHW(:,3) = AHW(:,3)/max(AHW(:,3));
subplot(4,9,14), hold on 
for j = 1:3, plot(GV.f, AH(:,j), 'Color', GV.plotColors(j)); end
set(gca, 'XScale', 'log'); 
subplot(4,9,23), hold on
for j = 1:3, plot(GV.f, AHW(:,j), 'Color', GV.plotColors(j)); end
set(gca, 'XScale', 'log'); 

for i=1:3  
    AXH{i}  = AX{i}.*AH; AXWH{i} = AXW{i}.*AHW; AXMH{i} = AX{i}.*AXW{i};
    subplot(4,9,14+i), hold on
    for j = 1:3, plot(GV.f,AXH{i}(:,j), 'Color', GV.plotColors(j)); end
    set(gca, 'XScale', 'log');

    subplot(4,9,23+i), hold on
    for j = 1:3, plot(GV.f,AXWH{i}(:,j), 'Color', GV.plotColors(j)); end
    set(gca, 'XScale', 'log');
    
    subplot(4,9,32+i), hold on
    for j = 1:3, plot(GV.f, AXMH{i}(:,j), 'Color', GV.plotColors(j)); end
    set(gca, 'XScale', 'log'); 
end

if r > 2
    AX = AXH; AXW = AXWH; AM = AXMH;
end
kCandH = find(AX{k}(:,2)==max(AX{k}(:,2))); 
kCandWH = find(AXW{k}(:,2)==max(AXW{k}(:,2))); 
kCandMH = find(AM{k}(:,2)==max(AM{k}(:,2))); 
[GV.f(kCandH) GV.f(kCandWH) GV.f(kCandMH)]

kOut = find(p(1:s(2)-1)==max(p(1:s(2)-1)));
if kOut==1
    AXFin = AX{2}.*AX{3}; AXWFin = AXW{2}*2.*AXW{3}*2; 
elseif kOut==2
    AXFin = AX{1}.*AX{3}; AXWFin = AXW{1}*2.*AXW{3}*2; 
else
    AXFin = AX{1}.*AX{2}; AXWFin = AXW{1}*2.*AXW{2}*2; 
end
AMFin = AXFin.*AXWFin;

if min(p(1:3)) > 2
    kCandH  = find(AXFin(:,2)==max(AXFin(:,2))); 
    kCandWH = find(AXWFin(:,2)==max(AXWFin(:,2))); 
    kCandMH = find(AMFin(:,2)==max(AMFin(:,2))); 
    [GV.f(kCandH) GV.f(kCandWH) GV.f(kCandMH)]
end

    subplot(4,9,18), hold on
    for j = 1:3, plot(GV.f,AXFin(:,j), 'Color', GV.plotColors(j)); end
    set(gca, 'XScale', 'log');

    subplot(4,9,27), hold on
    for j = 1:3, plot(GV.f,AXWFin(:,j), 'Color', GV.plotColors(j)); end
    set(gca, 'XScale', 'log');
    
    subplot(4,9,36), hold on
    for j = 1:3, plot(GV.f, AMFin(:,j), 'Color', GV.plotColors(j)); end
    set(gca, 'XScale', 'log'); 
end
% [k, HR, ~, PHR, SNR]    = fnGetHeartRateParams(AX, f, GV);
% [~, HRW, ~, PHRW, SNRW] = fnGetHeartRateParams(AXW, f, GV);




