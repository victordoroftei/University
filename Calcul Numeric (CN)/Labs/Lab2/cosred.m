function ccos = cosred(x)
  ccos = 0;
  u = 1;
  n = 0;
  n_semn = 0;

  while abs(u)
    ccos = ccos + u;
    n++;

    u = u * (-1) * (x ^ 2);
    u = u / ((2 * n - 1) * (2 * n));
  end

endfunction
