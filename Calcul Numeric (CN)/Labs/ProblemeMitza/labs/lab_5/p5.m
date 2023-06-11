function p5()
  n=10;

  #sparse matrix
  my_ones=ones(1,n);
  A=spdiags([(-1)*my_ones 5*my_ones (-1)*my_ones]',[1,0,-1],n,n);

  #dense matrix
  #A=ones(n,n);
  #for i=1:n
  #  A(i,i)=n+1;
  #endfor

  b=A*ones(n,1);

  t1=time();
  x_J=solveIterJacobi(A,b);
  #x_G=solveIterGaussSeidel(A,b);
  #x_S=solveIterSOR(A,b,1.15);
  t2=time();
  disp("Time");
  t2-t1
endfunction
