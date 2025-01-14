%% Uvoz in izris signalov
om = T19{:,4:6};
fig = figure; plot(om)
%% Dolocanje stacionarnega in dinamicnega dela
[x,y] = ginput(4);
x = round(x);
close(fig)
Nstac1 = x(1); Nstac2 = x(2);
Ndinam1 = x(3); Ndinam2 = x(4);

om_o = mean(om(Nstac1:Nstac2,:));
T = 1*60;
disp("Napaka po eni minuti bi bila: ")
e_phi = om_o*T

fs = 100; Ts = 1/fs;
S = eye(3);

for i = Ndinam1:Ndinam2
    %% izracun z osnovnimi meritvami
    om_norm = sqrt((om(i,1))^2+(om(i,2))^2+(om(i,3))^2);
    ur = om(i,:)./om_norm;
    %% izracun s kompenziranimi meritvami
%     om_norm = sqrt((om(i,1)-om_o(1))^2+(om(i,2)-om_o(2))^2+(om(i,3)-om_o(3))^2);
%     ur = (om(i,:)-om_o)./om_norm;    
    
    phi = om_norm*Ts;    
% izracun z rotacijsko matriko
%     R = fnRotacijskaMatrika(phi/180*pi, ur);
%     S = S*R;
% alternativen izracun z rotacijskim kvaternionom
    q = fnRotacijskiKvaternion(phi/180*pi, ur);
    S = fnRotirajSKvaternionom(S,q);
end
disp("Koncna orientacija:")
S
disp("Kot napake:")
acos((trace(inv(S))-1)/2)*180/pi



