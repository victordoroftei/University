# a)

syms x

a = sym(-1);
b = sym(1);

w = sqrt(1 + x) # Pondere Jacobi pe intervalul [-1, 1] cu alfa = 0, beta = 1 / 2

# Avem Gauss-Lobatto
wab = simplify((x - a) * (b - x) * w)

pi1 = orto_poly_sym_type('Jacobi', 1, sym(0), sym(1 / 2))  # Avem 1 de la 2n - 2, unde n = 3 (nr. noduri); alfa = 0, beta = 1 / 2
solutions = solve(pi1, x)

nodes = [a solutions']
coefs = gauss_coefs_sym(w, a, b, nodes)

rest_fara_f = sym(1) / factorial(4) * int(pi1 ^ 2 * wab, x, a, b)


# b)

f = cos(x) * sqrt(1 + x);
df4 = simplify(diff(f, x, 4) - f) + f
fplot(function_handle(df4), [-1, 1])

IG = eval(coefs * (cos(x) .* sqrt(1 + x))')
IO1 = integral(@(x) cos(x) .* sqrt(1 + x), -1, 1)
IO2 = quad(@(x) cos(x) .* sqrt(1 + x), -1, 1)
