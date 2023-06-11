function [coefs,eroare]=mcmmpSimplePoly(x,f,k)
  # daca a=coefs, atunci p(x)=a1x^3+a2x^2+a3x^1+a4x^0 (adica, primul coeficient
  # e pentru puterea predominanta)
  A=vander(x,k+1);
  [coefs,eroare]=solveQR(A,f');
  #[coefs,eroare]=supradetsis(A,f');
endfunction

#{
function [c,eroare]=supradetsis(A,f)
  [Q,R]=qr(A);
  [n,m]=size(A);
  b=Q'*f;
  c=R(1:m,:)\b(1:m);
  eroare=norm(b(m+1:n));
endfunction
#}
