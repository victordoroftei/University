n=10;
range=10;

#generarea lui A
d0=randi(range,1,n);
d1=randi(2*range+1,1,n-1)-1-range; #nr de la -10 la 10

d0(1:end-1)=d0(1:end-1)+abs(d1);
d0(2:end)=d0(2:end)+abs(d1);
d=[0 d1;d0;d1 0]';

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
