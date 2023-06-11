# a)

syms x

a = sym(0);
b = sym(inf);

w = exp(-x) # Pondere Laguerre pe intervalul [0, inf]

# Avem Gauss-Radau
wa = (x - a) * w

pi2 = orto_poly_sym_type('Laguerre', 2, sym(1))  # Avem 2 de la 2n - 1, unde n = 3 (nr. noduri)
solutions = solve(pi2, x)

nodes = [a solutions']
coefs = gauss_coefs_sym(w, a, b, nodes)

rest_fara_f = sym(1) / factorial(5) * int(pi2 ^ 2 * wa, x, a, b)


# b)

f = log(1 + exp(-x)) * exp(x);

df5 = simplify(diff(f, x, 5) - f) + f
syms y %facem substitutia exp(x)=1/y <=> x=-log(y); x>0 <=> 0<y<1;
df5y = subs(df5, exp(x), 1 / y);
fplot(function_handle(df5y), [0, 1])

rest_worst = abs(eval(rest_fara_f)) * 0.1

IG = eval(coefs * (exp(nodes) .* log(1 + exp(-nodes)))')
eroare_max = eval(rest_fara_f) * exp(0)

IO1 = integral(@(x) log(1 + e .^ (-x)), 0, inf)
IO2 = quad(@(x) log(1 + e .^ (-x)), 0, inf)
