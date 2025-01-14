%% simulacija delovanja komplementarnega filtra za rotacije g v 3D
%% podatki gibanja:
%% 1. preprosto vrtenje okoli z-osi za 90 deg
g0 = [0 1 0];
fs = 50; Ts = 1/fs; T = 10; N = fs*T;  
omega = zeros(N/2,3); omega(:,3) = linspace(0,4*pi/N,N/2)/Ts; 
omega = [omega; omega(end:-1:1,:)];
omega = [omega; omega; omega];
acc = zeros(size(omega)); 
phi = 0;
for n = 1:length(omega)
    omega_norm = sqrt(sum(omega(n,:).^2));
    u = omega(n,:)./omega_norm;
    phi = phi+omega_norm*Ts;
    acc(n,1) = sin(phi); acc(n,2) = cos(phi); 
end
FontSize = 24; figure;
subplot(121), plot(omega), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$\omega\ [n]$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(122), plot(acc), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$a\ [n]$', 'interpreter', 'latex', 'FontSize', FontSize)
legend({'$x$', '$y$', '$z$'}, 'interpreter', 'latex', 'FontSize', FontSize)

N = length(omega); 
omegaOffset = [0.055 0.05 -0.015];
omega = omega + omegaOffset + 0.1*(rand(N,3)-0.5); 
acc  = acc + [0.01 -0.015 -0.01] + 0.1*(rand(size(omega))-0.5);
acc  = acc + [0.1*sin(2*pi/N*100*(0:N-1))' 0.15*cos(2*pi/N*100*(0:N-1))' zeros(N,1)] +[0.01 -0.015 -0.01] + 0.1*(rand(N,3)-0.5);

lambda = 0.95;
g_comp = fnGComplimentaryFilter(omega, acc, g0, Ts, lambda);

g_gyro = g0; g_acc = acc;
for n = 2:length(acc)
    omega_norm = sqrt(sum(omega(n,:).^2));
    phi = omega_norm*Ts;
    u = omega(n,:)./omega_norm;
    g_gyro(n,:) = g_gyro(n-1,:)*fnRotacijskaMatrika(phi,u);    
end 

FontSize = 24; figure;
subplot(231)
plot(g_gyro), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$g_{gyro}$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(232)
plot(g_acc), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$g_{acc}$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(233)
plot(g_comp), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$g_{comp}$', 'interpreter', 'latex', 'FontSize', FontSize)

%%%% frekvencna vsebina
[~, A_gyro, ~] = fnFFT(g_gyro);
[~, A_acc, ~] = fnFFT(g_acc);
[~, A_comp, ~] = fnFFT(g_comp);
f = linspace(0,50,length(acc));

subplot(234), plot(f(1:130), A_gyro(1:130,:)), xlabel('$f\ [Hz]$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$G_{gyro}$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(235), plot(f(1:130), A_acc(1:130,:)), xlabel('$f\ [Hz]$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$G_{acc}$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(236), plot(f(1:130), A_comp(1:130,:)), xlabel('$f\ [Hz]$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$G_{comp}$', 'interpreter', 'latex', 'FontSize', FontSize)

omegaComp = omega - omegaOffset;
g_gyroComp(1,:) = g0; 
for n = 2:length(acc)
    omega_norm = sqrt(sum(omegaComp(n,:).^2));
    phi = omega_norm*Ts;
    u = omegaComp(n,:)./omega_norm;
    g_gyroComp(n,:) = g_gyroComp(n-1,:)*fnRotacijskaMatrika(phi,u);  
end 
g_accComp = fnLeakyIntegrator(acc, lambda);
[~, A_gyroComp, ~] = fnFFT(g_gyroComp);
[~, A_accComp, ~] = fnFFT(g_accComp);
figure;
subplot(231)
plot(g_gyroComp), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$g_{gyro}$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(232)
plot(g_accComp), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$g_{acc}$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(233)
plot(g_comp), xlabel('$n$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$g_{comp}$', 'interpreter', 'latex', 'FontSize', FontSize)

subplot(234)
plot(f(1:130), A_gyroComp(1:130,:)), xlabel('$f\ [Hz]$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$G_{gyrocomp}$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(235)
plot(f(1:130), A_accComp(1:130,:)), xlabel('$f\ [Hz]$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$G_{acccomp}$', 'interpreter', 'latex', 'FontSize', FontSize)
subplot(236)
plot(f(1:130), A_comp(1:130,:)), xlabel('$f\ [Hz]$', 'interpreter', 'latex', 'FontSize', FontSize), ylabel('$G_{comp}$', 'interpreter', 'latex', 'FontSize', FontSize)
