function x = lupsystem(A, b)

  [L, U, P] = lupdecomposition(A);

  # Rezolvam L * y = P * b cu forward substitution, pentru ca avem triunghi in jos in L.
  y = forwardsubs(L, P * b);

  # Rezolvam U * x = y cu backwards substitution, pentru ca avem triunghi in sus in U.
  x = backwardsubs(U, y);

  # Il avem pe x reprezentat pe o coloana, il transpunem ca sa fie pe o linie.
  x = x';

endfunction
