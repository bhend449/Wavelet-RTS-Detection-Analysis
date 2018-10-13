tic;
load('RTSdataClean.mat')
load('RTSdataNoise.mat')
% Denoising as detection


% 
imagewidth=1296;
imageheight=972;
numlevs = 4;
CoList = zeros(300,300);
tc = 1;
Mampval = [];
TauH = [];
TauC = [];

for b = 1:300
    disp(b)
    for c = 1:300
        clear lev
        Mseg = [];
        lev = [];
        sig = double(squeeze(RTSdata(b,c,:)));
        Cleansig = double(squeeze(CleanData(b,c,:)));
        clear tauH;
        clear tauL;                     % Handle variables for 
        th = 1;                         %       time constants
        tl = 1;
        tauH = [];
        tauL = [];
        
    %.....................................................
    % DWT
    %.....................................................
        [dwtsig, Uthreshold] = dwtden(sig,numlevs);
    %...............................................................
    % Remove transient spikes from DWT denoised signal
    %...............................................................
        scnlngth = 10;
        scnsig = tmpscreen(dwtsig,scnlngth);
    %............................................................
    %Perform arithmetic thresholding on transient free signal
    %............................................................
        thresh = 0.6745*std(sig);
        s = finthrsh(scnsig,thresh,scnlngth);
    %............................................................
    % Identify RTS transitions and create approximation
    %............................................................
        try
        [newpix, Mseg, Sigseg, lev, avglev] = approxmakerTestb(s,sig,thresh);
        catch
%         imname = sprintf('fail_%d_w.png',c);
%         img = plot(sig,'r');
%         hold on
%         saveas(gcf,imname,'png');
%         hold off
        end
    if all(newpix == newpix(1))
% 
%         imname = sprintf('a_%d_wa_%d.png',c,Cxy);
%         img = plot(sig,'r');
%         hold on
%         saveas(gcf,imname,'png');
%         hold off
    else
             %.........................................................................
    % Collect Time Constants
    %.........................................................................
                 tpoint = 0; 
                 tcount = 0;
                 for t = 2:1500
                     if newpix(t) < newpix(t-1)
                         tcount = tcount+1;
                         if tcount > 0
                            tauH(th) = ((t-1)-tpoint);
                            tpoint = t;
                            th = th + 1;
                         end
                     elseif newpix(t) > newpix(t-1)
                         tcount = tcount+1;
                         if tcount > 0
                            tauL(tl) = ((t-1)-tpoint);
                            tpoint = t;
                            tl = tl + 1;
                         end
                     end
                 end
             TauH(tc) = mean(tauH);
             TauL(tc) = mean(tauL);
             tc = tc+1;

    %.........................................................................
    % Collect Max Amplitudes
    %.........................................................................
            A = max(newpix)-min(newpix);
            Mampval = [Mampval A]; 
    %............................................................
    % Cross Corelation
    %............................................................
            newpix = newpix';
            try
                Cxy = mxcorr(Cleansig,newpix);
                CoList(b,c) = Cxy;
            catch
                newpix = newpix';
                Cxy = mxcorr(Cleansig,newpix);
                CoList(b,c) = Cxy;
            end
    %............................................................
    % Make Plots
    %............................................................
%         imname = sprintf('a_%d_wa_%d.png',c,Cxy);
%         img = plot(sig);
%         hold on
%         img = plot(newpix,'linewidth',3);
%         saveas(gcf,imname,'png');
%         hold off
    end
    end
end
toc;        
disp(mean(Cxy))