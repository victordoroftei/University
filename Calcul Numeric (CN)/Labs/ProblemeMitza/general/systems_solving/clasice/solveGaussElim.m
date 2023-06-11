function x=solveGaussElim(A,b)
  [A,b]=getGaussElim(A,b);
  x=backwardsubs(A,b);
endfunction
