 function pin=orto_poly_sym_type(type,n,aa=[],bb=[])
  syms x;
  switch type
   case 'Legendre'
      a=-sym(1);b=sym(1);
      w=sym(1);
   case 'Cebisev1'
      a=-sym(1);b=sym(1);
      w=1/sqrt(1-x^2);
   case 'Cebisev2'
      a=-sym(1);b=sym(1);
      w=sqrt(1-x^2);
   case 'Jacobi'
      a=-sym(1);b=sym(1);
      w=(1-x)^aa*(1+x)^bb;
   case 'Laguerre'
      a=sym(0);b=sym(Inf);
      w=x^aa*exp(-x);
   case 'Hermite'
      a=-sym(Inf);b=sym(Inf);
      w=exp(-x^2);
  endswitch
  pi0=sym(0); pi1=sym(1);
  [alpha,beta]=orto_coef_sym_type(type,sym(0:n-1),aa,bb);
  for k=1:n
   pin=(x-alpha(k))*pi1-beta(k)*pi0;
   pi0=pi1; pi1=pin;
  endfor
  pin=expand(pin);
 endfunction
