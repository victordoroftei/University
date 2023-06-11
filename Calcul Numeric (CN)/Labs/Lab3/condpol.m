function nr_cond = condpol(coefs, xi)
  n = length(coefs);
  coefs2 = coefs(2:n);

  %numarul de cond. a aflarii rad. xi a unei ec. pol.
  %coefs = coeficientii pol.
  coefs_der = polyder(coefs); %coef. derivatei lui p;
  nr_cond = polyval(abs(coefs2), abs(xi)) / abs(xi * polyval(coefs_der, xi));

endfunction
