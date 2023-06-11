function p3()
  m=[89,67,53,35,20];
  A=[1,1,1;1,1,0;0,1,1;1,0,0;0,0,1];

  [coefs,err]=solveQR(A,m')
endfunction
