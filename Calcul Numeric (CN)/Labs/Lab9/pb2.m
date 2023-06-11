x = [-1.024940 -0.949898 -0.866114 -0.773392 -0.671372 -0.559524 -0.437067 -0.302909 -0.159493 -0.007464];
y = [-0.389269 -0.322894 -0.265256 -0.216557 -0.177152 -0.147582 -0.128618 -0.121353 -0.127348 -0.148895];

len = length(x);
x_patrat = x .^ 2;
y_patrat = y .^ 2;

A = [y_patrat', (x .* y)', x', y', ones(len, 1)];
# Prima linie din A va fi de genul: [y1^2 x1*y1 x1 y1 1]

f = x_patrat';
[coefs_ec1, err_ec1] = supradetsys(A, f)

A = [y', ones(len, 1)];
# Prima linie din A va fi de genul: [y1 1]

f = x_patrat';
[coefs_ec2, err_ec2] = supradetsys(A, f)


