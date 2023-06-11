function [x,err]=solveQR(A,b)
  [m,n]=size(A);
  [A,b]=getQRApplication(A,b);
  x=backwardsubs(A,b(1:n));
  err=norm(b(n+1:m));
endfunction
