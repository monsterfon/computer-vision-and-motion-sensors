%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Animacija rotacij %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fnIzrisiKS(S)

addpath('arrow3')

arrow_X = arrow3([0 0 0], S(:,1)', 'b'); hold on
arrow_Y = arrow3([0 0 0], S(:,2)', 'r');
arrow_Z = arrow3([0 0 0], S(:,3)', 'g'); hold off
grid on
axis([-1.2 1.2 -1.2 1.2 -1.2 1.2])
daspect([1 1 1])
view([1,1,1])

% axis vis3d
