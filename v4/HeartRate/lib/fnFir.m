function y = fnFir(x, Wn, n)

b        = fir1(n, Wn);
%figure; freqz(b,1)
%figure; zplane(b,a)
y        = filter(b, 1, x);

