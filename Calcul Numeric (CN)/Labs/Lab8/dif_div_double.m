function T = dif_div_double(x, f, df)

  n = length(x);
  T = NaN(2* n, 2 * n);

  T(:, 1) = repelem(f, 2);
  T(1:2:end - 1, 2) = df;
  T(2:2:end - 2, 2) = diff(f) ./ diff(x);

  z = repelem(x, 2);

  for j = 3:2 * n

    for i = 1:2 * n - j + 1

      T(i, j) = (T(i + 1, j - 1) - T(i, j - 1)) / (z(i + j - 1) - z(i));

    endfor

  endfor

endfunction
