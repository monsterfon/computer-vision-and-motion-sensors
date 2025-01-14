function y = fnLeakyIntegrator(x, lambda)

y = zeros(size(x));
y(1,:) = (1-lambda)*x(1,:);
for i=2:length(x)
    y(i,:) = (1-lambda)*x(i,:)+lambda*y(i-1,:);
end
