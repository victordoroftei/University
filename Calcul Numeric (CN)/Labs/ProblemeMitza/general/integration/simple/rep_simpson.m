function arie=rep_simpson(f,a,b,n)
  h=(b-a)/n;
  x=a+h:h:b-h;
  x_mij=a+h/2:h:b-h/2;
  arie=(f(a)+2*sum(f(x))+4*sum(f(x_mij))+f(b))*(h/6);
endfunction
