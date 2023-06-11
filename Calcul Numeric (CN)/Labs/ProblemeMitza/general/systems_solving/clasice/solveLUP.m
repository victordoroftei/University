function x=solveLUP(A,b)
  #Ax=b
  [L,U,P,p]=getLUP(A);
  #L -> triunghilara inferior
  #U -> triunghiulara superior
  #LU=PA
  #Ax=b => PAx=Pb => LUx=Pb => L*(Ux)=Pb
  #y=forwardsubs(L,b(p));
  y=forwardsubs(L,P*b);

  #Ux=y
  x=backwardsubs(U,y);
endfunction
