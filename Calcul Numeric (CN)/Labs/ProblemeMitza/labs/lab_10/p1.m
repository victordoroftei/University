function p1()
  f=@(x) exp(-x.^2);
  a=-1;
  b=1;
  n=10;

  disp("Actual");
  integral(f,a,b)
  disp("Dreptunghiuri");
  rep_dreptunghi(f,a,b,n)
  disp("Trapeze");
  rep_trapez(f,a,b,n)
  disp("Simpson");
  rep_simpson(f,a,b,n)
endfunction
