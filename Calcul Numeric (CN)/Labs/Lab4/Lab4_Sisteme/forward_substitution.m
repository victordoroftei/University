function x = forward_substitution(L, b)
  n = length(b);
  x = zeros(1, n);
  for i=1:n
    x(i) = (b(i) - sum(L(i,1:i-1) .* x(1:i-1))) / L(i, i);
  endfor
  x = x';
endfunction
