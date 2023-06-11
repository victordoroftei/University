function [noduri, coeficienti, rest] = cuadratura_gauss(lambda, x, n)

  # Functia cuadratura_gauss primeste ca parametrii de intrare:
  # - lambda = lambda de la pondere
  # - x = variabila simbolica
  # - n = numarul de noduri

  # Functia are ca date de iesire:
  # - noduri = nodurile cuadraturii
  # - coeficienti = coeficientii cuadraturii
  # - rest = restul, fara f

  a = -sym(1);
  b = sym(1);

  # Functia pondere
  w = (1 - x ^ 2) ^ (1 / 3);

  # Calculam polinomul ortogonal pi_n, pentru ponderea de tip Gegenbauer, cu lambda primit ca parametru.
  lambda_sym = sym(lambda);
  pin = orto_poly_sym_type('Gegenbauer', n, lambda_sym);

  # Nodurile vor fi solutiile polinomului ortogonal.
  noduri = solve(pin)';

  coeficienti = gauss_coefs_sym(w, a, b, noduri);

  a_num = -1;
  b_num = 1;

  # Calculam restul, folosind formula de rest pentru cuadraturile Gauss.
  rest = sym(1) / factorial(2 * n) * int(pin ^ 2 * w, a_num, b_num);

endfunction
