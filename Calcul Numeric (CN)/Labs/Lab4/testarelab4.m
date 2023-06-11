n = 10;

V1 = [];
V2 = [];
V3 = [];
for i = 1:n

  V1 = [V1 1];
  V2 = [V2 10];
  V3 = [V3 1];

endfor

V = [V1' V2' V3'];  # vectorul cu valorile pe care le vor avea diagonalele matricei
                    # strict diagonal dominanta = sa aiba valorea absoluta de pe diagonala mai mare strict
                    # decat suma valorilor absolute ale celorlalte elemente de pe rand
                    # prin faptul ca dau diagonala sa fie full de 10, iar celelalte doua sa fie 1,
                    # avem asigurat acest lucru

D = [-1 0 1];       # vectorul cu indicii diagonalelor pe care vrem sa punem elementele
                    # tridiagonala = sa avem valori non-zero pe diagonala principala, si pe diagonalele de deasupra ei si de sub ea


A = spdiags(V, D, n, n);  # creeaza o matrice de n x n, cu valorile din V dispuse pe diagonalele cu indecsii din D
full(A)

b = [];
for i = 1:n

  b = [b sum(A(i, 1:n))];

endfor

b = b';
full(b)

disp("Voi reprezenta solutiile ca vectori linie, ca sa incapa pe ecran\n");
x_lup = lupsystem(A, b)
x_cholesky = choleskysystem(A, b)
