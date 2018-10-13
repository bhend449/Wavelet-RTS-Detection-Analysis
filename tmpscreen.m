function scnsig = tmpscreen(sig,scnlngth)
%...............................................................
% Remove transient spikes from DWT denoised signal
%...............................................................

% sig = dI{1};
% scnlngth = 10;
scnsig = sig;
for i = 2:(length(scnsig)-(scnlngth-1))
    if scnsig(i)~=scnsig(i-1)
        %disp("Change")
        for n = 2:scnlngth
            try
            if scnsig(i+n)==scnsig(i+n+1)
            else
                scnsig(i)=scnsig(i-1);
                %disp("Blip")
                break
            end
            catch
            end
        end
    end
end
