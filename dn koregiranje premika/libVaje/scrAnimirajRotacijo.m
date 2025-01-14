%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% racunanje kotne orientacije %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
om = 120*pi/180; fs = 100; Ts = 1/fs; T = 1; 
v = [1 1 1]/sqrt(3);
phi = om*Ts;

Sinit = eye(3);

S_RM = Sinit; 

figure; 
fnIzrisiKS(S_RM); pause(Ts);
for n = 1:fs*T
    R = fnRotacijskaMatrika(phi,v);
    S_RM = fnRotirajZMatriko(S_RM,R);
    fnIzrisiGKS(), hold on
    fnIzrisiKS(S_RM); pause(Ts/10);
end





