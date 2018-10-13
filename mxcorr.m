function Cxy = mxcorr(x,y)
%x = pix;
%y = newpix;

% create windows? Create some threshold? and voting system?

Cnum = sum((x-mean(x)).*(y-mean(y)));
Cdem = sqrt(sum((x-mean(x)).^2))*sqrt(sum((y-mean(y)).^2));

Cxy = Cnum/Cdem;





