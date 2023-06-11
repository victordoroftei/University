function t = testlab3(xi = 10)

  r = [];
  for i = 1:20

    r = [r i];

  endfor

  coefs = poly(r);

  nr_cond = condpol(coefs, xi);

  disp(nr_cond);

endfunction
