function Q = adquad(f, a, b, eps)

  c = (a + b) / 2;

  fa = f(a);
  fb = f(b);
  fc = f(c);

  Q = quadstep(f, a, b, eps, fa, fc, fb);

endfunction
