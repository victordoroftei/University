function p2()
  n=10;
  range=10;

  solutions=ones(n,1);
  A=randi(2*range+1,n,n)-1-range;
  for i=1:length(A)
    A(i,i)=sum(abs(A(i,:)))+1;
  endfor
  b=A*solutions;

  [x_S1,ni1,rho1]=solveIterSOR(A,b,1/2);
  [x_S2,ni2,rho2]=solveIterSOR(A,b,0);

  [x_S1 x_S2]
  [ni1 ni2]
  [rho1 rho2]
endfunction
