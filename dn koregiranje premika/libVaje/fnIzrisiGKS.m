function fnIzrisiGKS()

S = eye(3);
addpath('arrow3')

arrow_X = arrow3([0 0 0], S(:,1)', '-.'); hold on
arrow_Y = arrow3([0 0 0], S(:,2)', '-.');
arrow_Z = arrow3([0 0 0], S(:,3)', '-.'); hold off
grid on
axis([-1.2 1.2 -1.2 1.2 -1.2 1.2])
daspect([1 1 1])
view([1,1,1])
xlabel('$x$', 'interpreter', 'latex')
ylabel('$y$', 'interpreter', 'latex')
zlabel('$z$', 'interpreter', 'latex')

% axis vis3d
