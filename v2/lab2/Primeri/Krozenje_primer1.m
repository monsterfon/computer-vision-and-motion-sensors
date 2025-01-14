%%%%%%%%%%%%%%%%%%%%%%%%
%%%%    Krozenje   %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
clear all

r = 1; omega = 360; omegaRad = omega*pi/180; ar = omegaRad^2*r;
fs = 3600; T = 1/fs; N = fs*5; n = 1:N; t = n*T;

acc(1,1:N) = ar*sin(omegaRad*n*T);
acc(2,1:N) = -ar*cos(omegaRad*n*T);

% acc = acc + 0.2*randn(2,N)*9.81;
acc = acc + 9.81/100;

figure;
subplot(311)
plot(t,acc')
xlabel('$t\ [\mathrm{s}]$', 'Interpreter', 'Latex'), ylabel('$a\ [\mathrm{m/s^2}]$', 'Interpreter', 'Latex'), legend('$a_x$', '$a_y$', 'Interpreter', 'Latex')
axis([min(t) max(t) min(min(acc)) max(max(acc))])

v_zac = [- omegaRad*r; 0];
s_zac = [0; r];

s(:,1) = s_zac;
v(:,1) = v_zac;

for i = 2:length(acc)
    v(:,i) = v(:,i-1) + acc(:,i)*T;
    s(:,i) = s(:,i-1) + v(:,i-1)*T+1/2*acc(:,i)*T*T;
    % s(:,i) = s(:,i-1) + v(:,i)*T;
end

% v = fnIntegriraj(acc, T, v_zac); 
% s = fnIntegriraj(v, T, s_zac); 

subplot(312)
plot(t,v')
xlabel('$t\ [\mathrm{s}]$', 'Interpreter', 'Latex'), ylabel('$v\ [\mathrm{m/s}]$', 'Interpreter', 'Latex'), legend('$v_x$', '$v_y$', 'Interpreter', 'Latex')
axis([min(t) max(t) min(min(v)) max(max(v))])

subplot(313)
plot(t,s')
xlabel('$t\ [\mathrm{s}]$', 'Interpreter', 'Latex'), ylabel('$s\ [\mathrm{m}]$', 'Interpreter', 'Latex'), legend('$s_x$', '$s_y$', 'Interpreter', 'Latex')
axis([min(t) max(t) min(min(s)) max(max(s))])
