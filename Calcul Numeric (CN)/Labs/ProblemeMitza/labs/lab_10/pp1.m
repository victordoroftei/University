function pp1()
  f=@(x) cos(x);
  w=@(x) 1./(1+x.^2);
  a=-1;
  b=1;
  tk=linspace(a,b,10);

  disp("Integral");
  integral(@(x) f(x).*w(x),a,b)
  disp("Newton Cotes");
  [arie,err_ub]=int_newton_cotes(f,a,b,w,tk)
endfunction
