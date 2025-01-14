%% Primer spremljanja nadmorske visine rakete
clear zIn;
uIn = [39.72 40.02 39.97 39.81 39.75 39.60 39.77 39.83 39.73 39.87 39.81 39.92 39.78 39.98 39.76 39.86 39.61 39.86 39.74 39.87 39.63 39.67 39.96 39.8 39.89 39.85 39.9 39.81	39.81 39.68] - 9.81;
zIn = [-32.4 -11.1 18.0 22.9 19.5 28.5 46.5 68.9 48.2 56.1 90.6 104.9 140.9 148.0 187.6 209.2 244.6 276.4 323.5 357.3 357.4	398.3 446.7	465.1 529.4	570.4 636.8	693.3 707.3	748.5];
T   = 0.25;
F   = [1 T; 0 1];
B   = [0.5*T^2; T];
Q   = [T^4/4 T^3/2; T^3/2 T^2]*0.1^2;
H   = [1 0];
R   = 20^2;
x0  = zeros(2,1);
P0  = eye(2)*500;
[xOut,K] = fnKalman(zIn,F,B,H,Q,R,uIn,x0,P0);
aReal = 30; xReal = [0; 0];
for i=2:length(zIn)
    xNew(1,1)  = xReal(1,end) + xReal(2,end)*T + aReal/2*T^2;
    xNew(2,1)  = xReal(2,end) + aReal*T;
    xReal = [xReal xNew];
end
FontSize = 24; MarkerSize = 10; LineWidth = 1.2; figure; hold on, t = T*(1:length(xReal));
plot(t, xReal(1,:), 'g', 'LineWidth', LineWidth)
plot(t, zIn(1,:), 'b', 'LineWidth', LineWidth)
plot(t, xOut(1,:), 'r', 'LineWidth', LineWidth)
plot(t, xReal(1,:), 'sg', 'MarkerSize', MarkerSize)
plot(t, zIn(1,:), '.b', 'MarkerSize', MarkerSize)
plot(t, xOut(1,:), '*r', 'MarkerSize', MarkerSize)
ylabel('Visina [m]', 'FontSize', FontSize), xlabel('Cas [s]', 'FontSize', FontSize), legend({'Prava', 'Merjena', 'Kalman'}, 'FontSize', FontSize)
ax = gca; ax.FontSize = FontSize;