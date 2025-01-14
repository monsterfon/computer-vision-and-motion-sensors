function xNorm = fnNormalizeData(x, stdBit, meanNormBit)

m = mean(x);
xNorm     = x - ones(size(x,1),1)*m;
if meanNormBit
    xNorm     = xNorm./(ones(size(x,1),1)*m);
end
if stdBit == 1
    %xNorm = xNorm./(ones(size(x,1),1)*std(xNorm));
    xNorm = xNorm./std(xNorm(:,2));
end

