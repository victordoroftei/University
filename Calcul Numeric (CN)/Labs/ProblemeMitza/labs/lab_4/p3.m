function p3()
  n=10;
  A=randi(20,n,n);
  b=A*ones(n,1);
  solveGaussElim(A,b)
  solveLUP(A,b)
endfunction
