function x=solveCholesky(A,b)
  #Ax=b
  R=getCholesky(A);
  #R -> triunghiulara superior
  #R'-> triunghiulara inferior
  #R'R=A
  #Ax=b => R*Rx=b => R*(Rx)=b
  y=forwardsubs(R',b);
  #Rx=y
  x=backwardsubs(R,y);
endfunction
