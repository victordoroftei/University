function p4()
  n=10;
  A=randi(20,n,n);
  A=triu(A);
  A=A+A';
  for k=1:n
    A(k,k)=A(k,k)+sum(A(k,:));
  endfor
  b=A*ones(n,1);

  R=getCholesky(A);
  disp("Cholesky R");
  R
  disp("Cholesky R error");
  A-R'*R
  disp("Solution");
  solveCholesky(A,b)
endfunction
