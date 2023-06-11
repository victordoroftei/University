function x=solveCholeskyTrid(v1,v2,b)
  #rezolva un sistem Ax=b, pentru A HPD tridiagonala, unde v1 este diag.
  #principala a lui A, iar v2 este diagonala de sub diagonala principala
  [r1,r2]=getCholeskyTriad(v1,v2);

  n=length(b);
  y=zeros(n,1);
  #R'Rx=b
  #R'y=b
  for k=1:n
    y(k)=b(k);
    if k!=1
      y(k)=y(k)-r2(k-1)*y(k-1);
    endif
    y(k)=y(k)/r1(k);
  endfor

  #Rx=y
  x=zeros(n,1);
  for k=n:-1:1
    x(k)=y(k);
    if k!=n
      x(k)=x(k)-r2(k)*x(k+1);
    endif
    x(k)=x(k)/r1(k);
  endfor
endfunction
