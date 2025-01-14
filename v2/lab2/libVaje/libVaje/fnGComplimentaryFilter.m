function g_comp = fnGComplimentaryFilter(omega, acc, g0, Ts, lambda)

g_comp(1,:) = g0; 
for n = 2:length(acc)
    omega_norm = sqrt(sum(omega(n,:).^2));
    phi = omega_norm*Ts;
    u = omega(n,:)./omega_norm;
    g_gyro = g_comp(n-1,:)*fnRotacijskaMatrika(phi,u);
    g_acc = acc(n,:);
    g_comp(n,:) = lambda*g_gyro + (1-lambda)*g_acc;
end 