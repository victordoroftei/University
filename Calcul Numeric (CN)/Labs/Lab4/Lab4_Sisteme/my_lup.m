function x=my_lup(A, b)
  [L, U, P] = lup_decomposition(A);
  b = P * b;
  y = forward_substitution(L, b);
  x = backwards_substitution(U, y)';
endfunction
