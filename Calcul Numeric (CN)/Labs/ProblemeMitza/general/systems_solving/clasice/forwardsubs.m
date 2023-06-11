function x=forwardsubs(A,b)
  #rezolva sistemul A*x=b daca det(A)!=0 si A este triunghiulara inferior
  #principale
  n=length(b);
  x=b;
  for i=1:n
    x(i)=(b(i)-A(i,1:i-1)*x(1:i-1))/A(i,i);
  endfor
endfunction
