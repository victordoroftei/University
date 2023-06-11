function arie=rep_trapez(f,a,b,n)
  h=(b-a)/n;
  x=a+h:h:b-h;
  arie=(f(a)+2*sum(f(x))+f(b))*(h/2);
endfunction
