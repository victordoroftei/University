function Ainv=my_inverse(A)
  #calculeaza inversa unei matrici patratice cu det(A)!=0
  n=length(A);
  Ainv=A;

  [L,U,P]=LUP(A);
  for k=1:n
    b=zeros(n,1);
    b(k)=1;
    #Ax=b => PAx=Pb => LUx=Pb
    y=forwardsubs(L,P*b);
    Ainv(:,k)=backwardsubs(U,y);
  endfor
endfunction
