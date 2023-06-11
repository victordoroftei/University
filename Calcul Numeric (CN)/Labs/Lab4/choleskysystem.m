function x = choleskysystem(A, b)

  # Matrice simetrica, daca a_ij = a_ji, adica A = A_transpus
  # Matrice hermitiana, daca A = A*

  # Matrice SPD (simetric pozitiv definita) - matrice reala, cu conditia ca:
  #   - x_transpus * A * x > 0, x != 0, x - vector coloana de numere reale

  # Matrice HPD (hermitian pozitiv definita) - matrice complexa, cu conditia ca:
  #   - x_complement * A * x > 0, x != 0, x - vector coloana de numere reale
  #   - (x_complement e x*, e x_transpus pe care se aplica complementul de la nr. complexe)


  U = choleskydecomposition(A);  # U = R = B (de pe foaia mea)

  L = U'; # U fiind matrice cu triunghi sus, iar L fiind transpusa sa, inseamna ca L va fi cu triunghi jos
  y = forwardsubs(L, b);  # Asadar, folosim forward substitution

  x = backwardsubs(U, y);

  # Il avem pe x reprezentat pe o coloana, il transpunem ca sa fie pe o linie.
  x = x';

endfunction
