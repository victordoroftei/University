function arie=rep_dreptunghi(f,a,b,n)
  h=(b-a)/n;
  x_mij=a+h/2:h:b-h/2;
  arie=h*sum(f(x_mij));
endfunction
