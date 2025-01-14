function [xOut,K] = fnKalman(zIn,F,G,H,Q,R,u,x0,P0)
%% x n+1,n = Fx n,n + Gu + w
%% F je tranzicijska matrika 
%% u je vektor - "control variable" ali "input variable" - merljiv vhod sistema
%% G je kontrolna matrika - matrika, ki povezuje u in x
%% w je procesni sum - nemerljiv vhod sistema
%% H je matrika meritve
%% R je negotovost (varianca) meritev
%% Q je procesni šum (nihanja merjene vrednosti) - varianca w
%% x0 in P0 sta zacetni oceni merjene vrednosti in njene negotovosti

L            = size(F,2);
% xOut         = zeros(length(F),1);
xOut         = zeros(L,1);
xaposteriori = x0;
Paposteriori = P0;

for i=1:length(zIn)
    %% update/predict 
    xapriori     = F*xaposteriori+G*u(i);
    Papriori     = F*Paposteriori*F'+Q;
    %% correct
    K            = Papriori*H'*inv(H*Papriori*H'+R);
    xaposteriori = xapriori+K*(zIn(:,i)-H*xapriori);
    %Paposteriori = Papriori-K*H*Papriori; %% simplified, numerically
    %unstable equation
    Paposteriori = (eye(L)-K*H)*Papriori*(eye(L)-K*H)' + K*R*K';
    xOut(:,i)    = xaposteriori;
end

% F*(1-K*H)
% K
% zLI=fnLeakyIntegrator(zIn,1-H*K);
% 
% figure;
% plot(zIn,'r')
% hold on
% plot(xOut,'g')
% plot(zLI,'b')
% legend('meritev', 'Kalman', 'LI')