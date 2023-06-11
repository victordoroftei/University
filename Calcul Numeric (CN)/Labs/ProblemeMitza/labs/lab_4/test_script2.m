n=10;
range=10;

#generarea lui A
d0=randi(range,1,n);
d1=randi(2*range+1,1,n-1)-1-range; #nr de la -10 la 10

d0(1:end-1)=d0(1:end-1)+abs(d1);
d0(2:end)=d0(2:end)+abs(d1);
d=[0 d1;d0;d1 0]';

A=spdiags(d,[1 0 -1],n,n);
full(A)

#generarea lui b
b=A*ones(n,1);

#rezolvarea sistemelor
disp("GaussElim | LUP | Cholesky");
[full(solveGaussElim(A,b)) full(solveLUP(A,b)) full(solveCholesky(A,b))]
