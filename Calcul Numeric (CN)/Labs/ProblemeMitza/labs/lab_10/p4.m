function p4()
  f=@(x) exp(-x.^2);
  a=-1;
  b=1;
  n=10;
  err=1e-1;

  disp("Actual");
  integral(f,a,b)
  disp("Adaptiv Simpson");
  adapt_quad_simpson(f,a,b,err)
endfunction
