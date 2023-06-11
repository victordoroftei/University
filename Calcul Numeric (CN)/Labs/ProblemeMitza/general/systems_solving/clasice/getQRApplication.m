function [R,b]=getQRApplication(A,b)
  #daca avem un sistem Ax=b => QRx=b => Rx=Q\b
  #metoda returneaza R si b=Q\b, mai putin 0-urile
  #R triunghiulara superior
  [m,n]=size(A);
  for k=1:n
      x=A(k:m,k);
      x(1)=sign(x(1))*norm(x)+x(1);
      u=x/norm(x);
      reflector=eye(length(u))-2*u*u';

      A(k:m,k:n)=reflector*A(k:m,k:n);
      b(k:m)=reflector*b(k:m);
  endfor
  R=triu(A(1:n,:));
endfunction
