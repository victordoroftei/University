function p3()
  f=@(x) exp(-x.^2);
  a=-1;
  b=1;
  err=1e-5;
  method1=@(f,a,b,n) rep_dreptunghi(f,a,b,n);
  method2=@(f,a,b,n) rep_trapez(f,a,b,n);
  method3=@(f,a,b,n) rep_simpson(f,a,b,n);

  disp("Actual");
  integral(f,a,b)
  disp("Adaptiv Dreptunghiuri");
  adapt_quad(method1,f,a,b,err)
  disp("Adaptiv Trapeze");
  adapt_quad(method2,f,a,b,err)
  disp("Adaptiv Simpson");
  adapt_quad(method3,f,a,b,err)
endfunction
