function [H, dH] = hermitecubic(x, f, df, X)
  # input:
  # - x (vectorul de noduri ordonate cresc?tor)
  # - f (vectorul de valori în noduri), df (vectorul de valori ale derivatei în noduri)
  # - X (un punct între x(1) ?i x(end))

  # output: H si dH astfel încât:
  # - dac? X apar?ine intervalului [x(k),x(k+1)], atunci H este valoarea polinomului Hermite cu nodurile duble x(k) ?i x(k+1),
  # iar dH este valoarea derivatei în X

  H = [];
  dH = [];

  lX = length(X);
  for i = 1 : lX

    X_current = X(i);
    find_result = find(x == X_current);

    if (!isempty(find_result))

      H = [H; f(find_result)];
      dH = [dH; df(find_result)];

    else

      # putem face asta pt. ca stim ca x contine elemente ordonate crescator
      lower = find(x < X_current)(end); # luam pozitia ultimului element gasit care e mai mic decat X
      greater = find(x > X_current)(1); # luam pozitia primului element gasit care e mai mare decat X

      hermite_x = [x(lower), x(greater)];
      hermite_f = [f(lower), f(greater)];
      hermite_df = [df(lower), df(greater)];

      [H_hermite, dH_hermite] = hermite(hermite_x, hermite_f, hermite_df, X_current);

      H = [H; H_hermite];
      dH = [dH; dH_hermite];

    endif

  endfor

endfunction
