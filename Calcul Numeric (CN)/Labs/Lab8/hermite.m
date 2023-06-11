function [H, DH] = hermite(x, f, df, X)

  c = dif_div_double(x, f, df)(1, :);  # luam prima linie a tabelului de diferente divizate

  z = repelem(x, 2);
  P = 1;

  DP = 0;
  DH = 0;

  H = c(1);
  for i = 1:length(c) - 1

    DP = DP * (X - z(i)) + P;
    P *= X - z(i);
    H += c(i + 1) * P;
    DH += c(i + 1) * DP;

  endfor

endfunction
