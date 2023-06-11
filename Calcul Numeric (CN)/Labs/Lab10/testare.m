f = @(x) e .^ (-x .^ 2);
a = 0;
b = 1;
eps = 0.000001;

result_integral = integral(f, a, b)
result_adquad = adquad(f, a, b, eps)

diff = abs(result_integral - result_adquad)
