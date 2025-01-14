function [HR, conf] = fnEstimateHeartRate(RGBData, GV)
s = size(RGBData);
startStopDiff = zeros(s(2),3);
HR = []; conf = [];

for i = 1:s(2)
    RGBDataTemp        = interp1((1:GV.NStep:s(1)*GV.NStep),squeeze(RGBData(:,i,:)),(1:s(1)));
    RGBData_norm       = fnNormalizeData(RGBDataTemp,0,0);
    startStopDiff(i,:) = RGBData_norm(end,:) - RGBData_norm(1,:);

    [AX{i}, AXW{i}]    = fnDTFTROI(RGBData_norm, GV);
    A{i} = AX{i}.*AXW{i};
end

% for i = 1:s(2)-1
%     AX{i}(:,2) = AX{i}(:,2).*log10((11:2:810))';
% end

p     = sum(abs(startStopDiff),2);
k     = find(p(1:s(2)-1)==min(p(1:s(2)-1)));
kCand = find(A{k}(:,2)==max(A{k}(:,2))); 
conf  = 1/max([p(k) 1])*100;

kTemp = find(A{s(2)}(:,3)==max(A{s(2)}(:,3))); 
kTempInter = kTemp + 50 + find(A{s(2)}(kTemp+50:kTemp+120,3)==max(A{s(2)}(kTemp+50:kTemp+120,3))) - 1;
r = A{s(2)}(kTemp,3)/A{s(2)}(kTempInter,3);

if r > 2
    AHX  = max(AX{s(2)})*1.05-AX{s(2)}; AHX(:,1) = AHX(:,1)/max(AHX(:,1)); AHX(:,2) = AHX(:,2)/max(AHX(:,2)); AHX(:,3) = AHX(:,3)/max(AHX(:,3));
    AHXW = max(AXW{s(2)})*1.05-AXW{s(2)}; AHXW(:,1) = AHXW(:,1)/max(AHXW(:,1)); AHXW(:,2) = AHXW(:,2)/max(AHXW(:,2)); AHXW(:,3) = AHXW(:,3)/max(AHXW(:,3));
    
    for i = 1:s(2)-1 
        A{i}  = A{i}.*AHX.*AHXW;
    end
    kCand = find(A{k}(:,2)==max(A{k}(:,2)));
end

if min(p(1:s(2)-1)) > 2 
    if s(2) == 4
        kFin = find(p(1:s(2)-1)==max(p(1:s(2)-1)));
        if kFin==1
            AXFin = A{2}.*A{3}; 
        elseif kFin==2
            AXFin = A{1}.*A{3};
        else
            AXFin = A{1}.*A{2}; 
        end    
    else
        AXFin = A{1}.*A{2};
    end
    kCand = find(AXFin(:,2)==max(AXFin(:,2))); 
end

HR   = GV.f(kCand);
%figure; plot(GV.f, AXFin)








