function [arie,err_ub]=int_newton_cotes(f,a,b,w,tk)
  n=length(tk);
  wk=zeros(1,n);
  for i=1:n
    ind=[1:i-1,i+1:n];
    lk=@(x) polyval(poly(tk(ind)),x);
    func=@(x) lk(x).*w(x);
    wk(i)=integral(func,a,b)/prod(tk(i)-tk(ind));
  endfor
  arie=sum(wk.*f(tk));
  if nargout>1
    syms x
    f_der=sym(f);
    f_der=diff(f_der,x,n);
    f_der=function_handle(f_der,'vars',[x]);
    fmax_val=-fminbnd(@(x) (-1)*f_der(x),a,b);

    um=@(x) polyval(poly(tk),x);
    func=@(x) um(x).*w(x);
    err_ub=integral(func,a,b)*fmax_val/factorial(n);
  endif
endfunction
