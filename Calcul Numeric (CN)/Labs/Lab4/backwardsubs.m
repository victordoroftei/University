function x = backwardsubs(A, b)

  n = length(b);
  x = zeros(n, 1);
  for i = n:-1:1

    x(i) = (b(i) - A(i, i + 1 :end) * x(i + 1:end)) / A(i, i);

  endfor

endfunction
