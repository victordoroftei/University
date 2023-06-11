x = sym('x');

# lambda va fi 5 / 6, deoarece este solutia lui lambda - 1 / 2 = 1 / 3
lambda = 5 / 6;

# Vom avea n = 5 noduri.
n = 5;

[noduri, coeficienti, rest] = cuadratura_gauss(lambda, x, n)

disp("Valoarea aproximarii este:")
aproximare = eval(coeficienti * cos(noduri)')

# Derivata lui cos(x) de ordin 10, in functie de cos(x).
df = diff(cos(x), x, 2 * n);
rest_cos = simplify(df * rest);

# Cum derivatele lui cos(x) sunt mai mici ca 1, vom lua 1 drept valoare a lui cos(x), pentru calculul erorii maxime.
rest_final = subs(rest_cos, cos(x), 1);
rest_final = abs(eval(rest_final))
