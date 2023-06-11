function x=backwards_substitution(U, b)
  n = (length(b));
  x = zeros(1, n);
  for i=n:-1:1
    x(i) = (b(i) - sum(U(i, i+1:n) .* x(i+1:n))) / U(i, i);
  endfor
endfunction
