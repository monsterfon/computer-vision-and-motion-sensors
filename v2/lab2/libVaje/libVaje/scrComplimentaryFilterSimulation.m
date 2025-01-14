%% simulacija delovanja komplementarnega filtra

%% podatki preprostega vrtenja okoli z-osi za 45 deg
fs = 50; Ts = 1/fs; T = 10; N = fs*T; phiz = pi/4; 
omz(1:N) = phiz/N; ax(1:N) = sin((0:N-1)*phiz/N); ay(1:N) = cos((0:N-1)*phiz/N);

%% modeliranje nenatancnih senzorjev
omsz = omz + 0.1 + 0.1*(rand(1,N)-0.5);
asx  = ax + 0.01 + 0.1*(rand(1,N)-0.5);
asy  = ay + 0.01 + 0.1*(rand(1,N)-0.5);
FontSize = 24; figure;
subplot(211), plot(omsz), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$\omega_{z}$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(212), hold on, plot([asx' asy']), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$a_{x},\ a_{y}$', 'interpreter', 'latex', 'FontSize', FontSize)

phi = (0:N-1)*phiz/N;
phi_acc = atan(asx./asy);
phi_gyro(1) = 0; 
for n = 2:N
    phi_gyro(n) = phi_gyro(n-1) + omsz(n)*Ts;
end
figure; 
plot([phi' phi_acc' phi_gyro']*180/pi), 
xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize)
ylabel('$\varphi\ [n]$', 'interpreter', 'latex', 'FontSize', FontSize)
legend({'$\varphi_{correct}$' '$\varphi_{acc}$' '$\varphi_{gyro}$'}, 'interpreter', 'latex', 'FontSize', FontSize)

lambda = 0.95; 
phi_comp(1) = lambda*(omsz(1)*Ts) + (1-lambda)*phi_acc(1); 
for n = 2:N
    phi_comp(n) = lambda*(phi_comp(n-1) + omsz(n)*Ts) + (1-lambda)*phi_acc(n);
end 
figure; plot([phi' phi_acc' phi_gyro' phi_comp']*180/pi), 
xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize)
ylabel('$\varphi\ [n]$', 'interpreter', 'latex', 'FontSize', FontSize)
legend({'$\varphi_{correct}$' '$\varphi_{acc}$' '$\varphi_{gyro}$', '$\varphi_{comp}$'}, 'interpreter', 'latex', 'FontSize', FontSize)

