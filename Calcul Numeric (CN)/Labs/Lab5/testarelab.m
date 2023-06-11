n = 10;

A = diag(5 * ones(n, 1), 0) + diag(-ones(n - 1, 1), 1) + diag(-ones(n - 1, 1), -1) + diag(-ones(n - 3, 1), 3)+ diag(-ones(n - 3, 1), -3);
b = [3; 2; 2; ones(n - 6, 1); 2; 2; 3];

x_jacobi = jacobi(A, b, 10);
x_gauss = gauss(A, b, 10);
x_sor = sor(A, b, 1.15, 10);
[x_jacobi, x_gauss, x_sor]
