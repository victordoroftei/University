n=10;
val1=2;
val0=2*val1+1;

#generarea lui A
my_diag=ones(1,n);
d=[val1*my_diag;val0*my_diag;val1*my_diag]';

A=spdiags(d,[1 0 -1],n,n);

#generarea lui b
b=A*ones(n,1);

#aflarea omega_optim pentru SOR (pentru A tridiagonal)
MJ=diag(diag(A));NJ=MJ-A;TJ=MJ\NJ;
rhoJ=max(abs(eig(TJ)));
omega_optim=2/(1+sqrt(1-rhoJ^2));

#rezolvarea sistemelor
[x1,ni1,rho1]=solveIterJacobi(A,b);
[x2,ni2,rho2]=solveIterGaussSeidel(A,b);
[x3,ni3,rho3]=solveIterSOR(A,b,omega_optim);
disp("Jacobi|GaussSeidel|SOR");
solutii=[x1 x2 x3]
numar_iteratii=[ni1 ni2 ni3]
raze_spectrale=[rho1 rho2 rho3]
