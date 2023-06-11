function pin=orto_poly_sym(w,a,b,n,x)
  if nargin<5
    syms x
  endif
  if n<1
    pin=sym(n+1);
    return;
  endif
  for k=1:n
    if k==1
      pi0=sym(0); pi1=sym(1);
      int_pi0=sym(0);int_pi1=int(w,x,a,b);
      alpha=int(x*w,x,a,b)/int_pi1;
      beta=int_pi1;
    else
      pi0=pi1;pi1=pin;
      pi1_w=w*pi1^2;
      int_pi0=int_pi1;int_pi1=int(pi1_w,x,a,b);
      alpha=int(x*pi1_w,a,b)/int_pi1;
      beta=int_pi1/int_pi0;
    endif
    pin=(x-alpha)*pi1-beta*pi0;
  endfor
  pin=expand(pin);
endfunction
