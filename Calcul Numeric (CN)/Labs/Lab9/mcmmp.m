function [coefs, eroare] = mcmmp(x, f, k)

  # Se returneaza coeficientii pt polinomul nostru

  A = vander(x, k + 1);
  [coefs, eroare] = supradetsys(A, f'); # daca f e dat linie, trebuie dat mai departe sub forma de coloana

endfunction
