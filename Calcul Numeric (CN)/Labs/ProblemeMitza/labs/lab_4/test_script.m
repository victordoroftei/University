n=10;
val1=2;
val0=2*val1+1;

#generarea lui A
my_diag=ones(1,n);
d=[val1*my_diag;val0*my_diag;val1*my_diag]';

A=spdiags(d,[1 0 -1],n,n);
full(A)

#generarea lui b
b=A*ones(n,1);

#rezolvarea sistemelor
disp("LUP");
x=solveLUP(A,b)
disp("Cholesky");
x=solveCholesky(A,b)
