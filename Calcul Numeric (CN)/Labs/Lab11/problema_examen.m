syms x

a = -sym(1)
b = sym(1)

w = 1 / sqrt(1 - x ^ 2)
wab = simplify((x - a) * (b - x) * w)

pi2 = orto_poly_sym_type('Cebisev2', 2)
solutii = solve(pi2, x)

nodes = [a solutii' b]

coefs = gauss_coefs_sym(w, a, b, nodes)
##p = x ^ 5 + x ^ 4 + 7 * x ^ 2 + x
##int(p * w, x, -1, 1)
##coefs * subs(p, x, nodes)'
rest_fara_f = 1 / factorial(6) * int(pi2 ^ 2 * wab, x, a, b)
syms df4_xi
rest = rest_fara_f * df4_xi

# b)

IG = eval(coefs * exp(nodes)')
eroare_max = eval(rest_fara_f) * exp(1)

IO1 = integral(@(x) exp(x) ./ sqrt(1 - x .^ 2), -1, 1)
IO2 = quad(@(x) exp(x) ./ sqrt(1 - x .^ 2), -1, 1)
