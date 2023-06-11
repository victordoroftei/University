function LX = lagrange_classic(x, f)

  m = length(x);
  xsym = sym('X');

  LX = 0;
  for k = 1:m

    lk = prod(xsym - x([1:k - 1, k + 1:m])) / prod(x(k) - x([1:k - 1, k + 1:m]));
    term = f(k) * lk;

    LX = LX + term;

  endfor

endfunction
