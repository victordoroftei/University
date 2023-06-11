function p3()
  #primul sistem
  n=10;
  A=diag(5*ones(n,1),0);
  A=A+diag((-1)*ones(n-1,1),1)+diag((-1)*ones(n-1,1),-1);
  b=[4;3*ones(n-2,1);4];

  x_J=solveIterJacobi(A,b);
  x_G=solveIterGaussSeidel(A,b);
  x_S=solveIterSOR(A,b,1/2);
  [x_J,x_G,x_S]

  #al doilea sistem
  n=10;
  A=diag(5*ones(n,1),0);
  A=A+diag((-1)*ones(n-1,1),1)+diag((-1)*ones(n-1,1),-1);
  A=A+diag((-1)*ones(n-3,1),3)+diag((-1)*ones(n-3,1),-3);
  b=[3;2;2;ones(n-6,1);2;2;3];

  x_J=solveIterJacobi(A,b);
  x_G=solveIterGaussSeidel(A,b);
  x_S=solveIterSOR(A,b,1/2);
  [x_J,x_G,x_S]
endfunction
