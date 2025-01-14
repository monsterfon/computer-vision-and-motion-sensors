addpath('../libVaje')

fvz = 48000;

T = 30;
N = fvz*T;
n = 0:N-1;
FontSize = 24;

%% 1. generiranje sinusa 400 Hz
f1 = 400;
x1 = sin(2*pi/fvz*f1*n);
X1 = fnFFT(x1); f = linspace(0, fvz - fvz/N, N);
figure 
plot(f, abs(X1), 'LineWidth', 1.4), set(gca, 'FontSize', 16)
xlabel('$f$ [Hz]', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$Ax\ (f)$', 'interpreter', 'latex', 'FontSize', FontSize)

p = audioplayer(x1, fvz);
play(p)
audiowrite('Sinus400Hz.wav', x1, fvz)

%% 2. generiranje vsote sinusov 200 Hz, 400 Hz, 800 Hz, 1600 Hz, 3200 Hz, 6400 Hz
f2 = 200; 
x2 = sin(2*pi/fvz*f2*n) + sin(2*pi/fvz*2*f2*n) + sin(2*pi/fvz*4*f2*n) + sin(2*pi/fvz*8*f2*n) + sin(2*pi/fvz*16*f2*n);
X2 = fnFFT(x2);

figure 
plot(f, abs(X2), 'LineWidth', 1.4), set(gca, 'FontSize', 16)
xlabel('$f$ [Hz]', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$Ax\ (f)$', 'interpreter', 'latex', 'FontSize', FontSize)

x2 = x2./max(abs(x2));
p = audioplayer(x2, fvz);
play(p)
audiowrite('VsotaSinusov200Hz.wav', x2, fvz)

%% 3. generiranje preleta frekvenc (sweep) od 40 Hz do 18 kHz
f3_zac = 40; 
f3_kon = 18000; 
t = 0:1/fvz:T-1/fvz;
x3 = chirp(t, f3_zac, t(end), f3_kon);
X3 = fnFFT(x3);

figure 
plot(f, abs(X3), 'LineWidth', 1.4), set(gca, 'FontSize', 16)
xlabel('$f$ [Hz]', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$Ax\ (f)$', 'interpreter', 'latex', 'FontSize', FontSize)

x3 = x3./max(abs(x3));
p = audioplayer(x3, fvz);
play(p)
audiowrite('Sweep 40Hz do 18 kHz.wav', x3, fvz)

%% 4. generiranje belega šuma
X4 = exp(-1i*(rand(size(X1))*2*pi-pi));
k_pol = N/2;
X4(end:-1:k_pol+2) = conj(X4(2:k_pol));

figure 
plot(f, abs(X4), 'LineWidth', 1.4), set(gca, 'FontSize', 16)
xlabel('$f$ [Hz]', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$Ax\ (f)$', 'interpreter', 'latex', 'FontSize', FontSize)

x4 = real(ifft(X4));
x4 = x4./max(abs(x4)); 
p = audioplayer(x4, fvz);
play(p)
audiowrite('White noise.wav', x4, fvz)