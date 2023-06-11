function p2()
  A=randi(20,5,5);
  b=A*ones(5,1);
  solveLUP(A,b)
endfunction
