function p1()
  A=randi(20,5,5);
  b=A*ones(5,1);
  solveGaussElim(A,b)
endfunction
