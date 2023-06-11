function arie = simpson_rep(f, a, b, n)

  h = (b - a) / n;
  x = a + h : h : b - h;
  x_mij = a + h / 2 : h : b - h / 2;
  arie = (h / 6) * (f(a) + 2 * sum(f(x)) + f(b) + 4 * sum(f(x_mij)));

endfunction
