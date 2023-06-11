 function c=taylor_coef(f, n, a = 0)
  if n < 0
    c=sym(0);
    return;
  else
    x = sym('x');
    fprim = diff(f, x, n);      # f'
    fprim0 = subs(fprim, x, 0); # cred ca aici ar trebui a in loc de 0?
    c = fprim0 / factorial(n);  # c_n = f'(n) (0) / n!
  end
 endfunction
