function p4()
  n=10;
  range=10;

  solutions=(1:n)';
  A=randi(2*range+1,n,n)-1-range;
  for i=1:length(A)
    A(i,i)=sum(abs(A(i,:)))+1;
  endfor
  b=A*solutions;

  x_J=solveIterJacobi(A,b);
  x_G=solveIterGaussSeidel(A,b);
  x_S=solveIterSOR(A,b,1/2);
  [x_J,x_G,x_S]
endfunction
