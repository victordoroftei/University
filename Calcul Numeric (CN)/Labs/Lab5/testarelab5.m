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
full(b)'

[x_jacobi, ni_jacobi, rho_jacobi] = model_sys_lin(A, b, "Jacobi");
x_jacobi = x_jacobi';

[x_gauss, ni_gauss, rho_gauss] = model_sys_lin(A, b, "Gauss");
x_gauss = x_gauss';

omega_optim = 2 / (1 + sqrt(1 - rho_jacobi ^ 2));
[x_sor, ni_sor, rho_sor] = model_sys_lin(A, b, "SOR", omega_optim);
x_sor = x_sor';

x_jacobi
ni_jacobi
x_gauss
ni_gauss
x_sor
ni_sor
