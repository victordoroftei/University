function p1()
  n=10;
  range=10;

  solutions=ones(n,1);
  A=randi(2*range+1,n,n)-1-range;
  for i=1:length(A)
    A(i,i)=sum(abs(A(i,:)))+1;
  endfor
  b=A*solutions;

  x_J=solveIterJacobi(A,b);
  [x_J]
endfunction
