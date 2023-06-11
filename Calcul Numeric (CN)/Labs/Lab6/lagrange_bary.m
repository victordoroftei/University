function LX = lagrange_bary(x, f, X)

  w = coefs_bary(x);
  LX = X;
  for i = 1:length(X)

    x_poz = find(X(i) == x);

    if isempty(x_poz)
      LX(i) = sum(w ./ (X(i) - x) .* f) / sum(w ./ (X(i) - x));
    else
      LX(i) = f(x_poz);
    endif

  endfor

endfunction
