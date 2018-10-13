function [newpix, Mseg, Sigseg, lev, avglev] = approxmakerTestb(s,sig,thresh)
[locs pks] = peakseek(s,4,1);
Mseg = [];
Sigseg = [];
lev = [];
try
    pklocs = locs;
    for n = 1:pklocs(1)
        newpix(n) = mean(sig(1:pklocs(1)));
    end
        Mseg = [Mseg mean(sig(1:pklocs(1)))];
        Sigseg = [Sigseg std(sig(1:pklocs(1)))];
        
    for n = 2:numel(pklocs)
        newpix(pklocs(n-1):pklocs(n)) = mean(sig(pklocs(n-1):pklocs(n)));
        Mseg = [Mseg mean(sig(pklocs(n-1):pklocs(n)))];
        Sigseg = [Sigseg std(sig(pklocs(n-1):pklocs(n)))];
    end

    for n = (max(pklocs)+1):length(sig)
        newpix(n) = mean(sig(max(pklocs):length(sig)));
    end
        Mseg = [Mseg mean(sig(max(pklocs)+1:length(sig)))];
        Sigseg = [Sigseg std(sig(max(pklocs):length(sig)))];
        
catch
end

sm = sort(Mseg);
avglev = [];
j = 1;
lev(j) = sm(1);
for h = 2:length(sm)
    if abs(sm(h)-lev(j)) > thresh
        j = j+1;
        lev(j) = sm(h);
%     else
%         lev(j) = mean([lev(j) sm(h)]);
    end
end
a = 1;
for h = 1:length(sm)
    for j = 1:length(lev)
        if abs(sm(h)-lev(j)) <= thresh
            avglev(j) = mean([sm(h) lev(j)]);
            a = a+1;
        end
    end
end

for h = 1:length(newpix)
    for j = 1:length(avglev)
        if abs(newpix(h) - avglev(j)) < thresh
            newpix(h) = avglev(j);
        end
    end
end
