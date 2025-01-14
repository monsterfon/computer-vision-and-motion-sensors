function phi = fnArg(c)

C      = round(c*1000000)/1000000;
phi    = atan2(imag(C),real(C));
%
phi(find(real(C)==0&imag(C)==0)) = NaN;
