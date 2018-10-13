function [dwtsig, Uthreshold] = dwtden(sig,numlevs)

%.....................................................
% DWT
%.....................................................
[pA, pD] = dwt(sig,'haar');
sighat = median(abs(pD))/0.6745;
Uthreshold = sighat*sqrt(2*log(length(pD)));
pD(abs(pD)<abs(Uthreshold)) = 0; 
npix = idwt(pA,pD,'haar');
dA{1} = pA;
dD{1} = pD;

for i=2:numlevs
    clear pA;
    clear pD;
    [pA, pD] = dwt(dA{i-1},'haar');
    sighat = median(abs(pD))/0.6745;
    Uthreshold = sighat*sqrt(2*log(length(pD)));
    pD(abs(pD)<abs(Uthreshold)) = 0; 
    dA{i}= pA;
    dD{i}= pD;
end

dI{numlevs} = idwt(dA{numlevs},dD{numlevs},'haar');
for i = numlevs-1:-1:1
    try
        dI{i} = idwt(dI{i+1},dD{i},'haar');
    catch
       dI{i+1} = dI{i+1}(1:length(dI{i+1})-1);
       dI{i} = idwt(dI{i+1},dD{i},'haar');
    end
end
dwtsig = dI{1};
