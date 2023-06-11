# Voi alege functia f(x) = 5x - 3
x = [ -2  0   5];
f = [-13 -3  22];

L = lagrange_classic(x, f)
simple_L = simplify(L);
disp("L simplificat:");
disp(simple_L);
