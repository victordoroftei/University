function pp2()
  f=@(x) exp(-x.^2);
  a=-1;
  b=1;
  n=5;
  err=1e-5;
  method1=@(f,a,b,n) rep_dreptunghi(f,a,b,n);
  method2=@(f,a,b,n) rep_trapez(f,a,b,n);
  method3=@(f,a,b,n) rep_simpson(f,a,b,n);

  disp("Integral");
  integral(f,a,b)
  disp("Quad");
  quad(f,a,b)

  disp("Dreptunghiuri");
  rep_dreptunghi(f,a,b,n)
  disp("Trapeze");
  rep_trapez(f,a,b,n)
  disp("Simpson");
  rep_simpson(f,a,b,n)

  disp("Adaptiv Dreptunghiuri");
  adapt_quad(method1,f,a,b,err)
  disp("Adaptiv Trapeze");
  adapt_quad(method2,f,a,b,err)
  disp("Adaptiv Simpson");
  adapt_quad(method3,f,a,b,err)

  disp("Adaptiv Simpson");
  adapt_quad_simpson(f,a,b,err)
endfunction
