function s = finthrsh(scnsig,thresh,scnlngth)
%............................................................
%Perform arithmetic thresholding on transient free signal
%............................................................
clear pk
clear loc
pk = [];
loc = [];
j = 1;

for n = 1:(1500-scnlngth)
    s(n) = scnsig(n+1)-scnsig(n);
end

s((1500-scnlngth):1500) = 0;
s(abs(s)<abs(thresh)) = 0;

try
for n = 1:length(s)
    if s(n)~=0
        pk(j) = s(n);
        loc(j) = n;
        j = j+1;
    end
end

for k = 2:length(pk)
    Carl = pk(k)*pk(k-1);
    if Carl > 0
        if (abs(pk(k)+pk(k-1))-abs(pk(k-2)))<1
            s(loc(k-1)) = 0;
        end
    end
end    
catch
end
s = abs(s);
% DO SOMETHING ABOUT CONSECUTIVE DROPS OR RISES

% If s(n) and s(n+1) are the same sign & s(n) + s(n+1) is roughly = - s(n-1)
% then set s(n+1) = s(n)+ s(n+1)