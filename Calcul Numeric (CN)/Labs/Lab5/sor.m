function x = sor(A, b, omega, num_iter)

  n = length(b);
  x_old = zeros(n, 1);
  x_new = x_old;

  for k = 1:num_iter

    for i = 1:n

      x_new(i) = omega / A(i, i) * (b(i) - A(i, 1:i - 1) * x_new(1:i - 1) - A(i, i + 1:n) * x_old(i + 1:n)) + (1 - omega) * x_old(i);

    endfor

    x_old = x_new;

  endfor

  x = x_new;

endfunction
