function p3()
  x=4*pi;
  digits=1144;
  m=6;
  k=8;

  disp("Basic");
  disp("cos");
  my_cos_pade(x,m,k)
  disp("sin");
  my_sin_pade(x,m,k)

  disp("Better");
  disp("cos");
  my_better_cos_pade(x,m,k,digits)
  disp("sin");
  my_better_sin_pade(x,m,k,digits)
endfunction
