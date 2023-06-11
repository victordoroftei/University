function x=solveRectangularSimple(A,b)
  #A -> matrice de mxn
  #b -> matrice de mx1
  #x -> matrice de nx1
  #m>n
  x=solveLUP(A'*A,A'*b);
endfunction
