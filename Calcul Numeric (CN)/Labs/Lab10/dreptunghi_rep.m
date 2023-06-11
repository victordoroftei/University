function arie = dreptunghi_rep(f, a, b, n)

  h = (b - a) / n;
  x_mij = a + h / 2 : h : b - h / 2;
  arie = sum(f(x_mij)) * h; # Inaltimea dreptunghiului e f(x); Latimea e h;

endfunction
