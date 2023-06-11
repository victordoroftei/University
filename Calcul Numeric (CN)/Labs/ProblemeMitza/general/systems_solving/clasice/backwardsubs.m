function x=backwardsubs(A,b)
  #rezolva sistemul A*x=b daca det(A)!=0 si A triunghiulara superior
  n=length(b);
  x=b;
  for i=n:-1:1
    x(i)=(b(i)-A(i,i+1:end)*x(i+1:end))/A(i,i);
  endfor
endfunction
