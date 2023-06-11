function [H_vec, DH_vec] = hermite_vectorized(x, f, df, X)

  c = dif_div_double(x, f, df)(1, :);  # luam prima linie a tabelului de diferente divizate

  z = repelem(x, 2);
  lx = length(X);

  H_vec = [];
  DH_vec = [];

  for k = 1:lx

    DP = 0;
    DH = 0;
    P = 1;

    H = c(1);
    for i = 1:length(c) - 1

      DP = DP * (X(k) - z(i)) + P;
      P *= X(k) - z(i);
      H += c(i + 1) * P;
      DH += c(i + 1) * DP;

    endfor

    H_vec = [H_vec H];
    DH_vec = [DH_vec DH];

  endfor

endfunction
