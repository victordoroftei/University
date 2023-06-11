function pp1()
  f=@(x) exp(x);
  df=@(x) exp(x);

  x=[0,1,2];
  X=0.25

  disp("Actual");
  val=exp(X)

  disp("Delimitation");
  interpolation_rest(x,X,exp(2))

  disp("Hermite");
  valH=interpolationHermit(x,f(x),df(x),X)
  disp("Hermite absolute error");
  abs(valH-val)
  disp("Hermite relative error");
  abs(valH-val)/abs(val)

  disp("LaGrange");
  valLG=lagrange_bary(x,f(x),X)
  disp("LaGrange absolute error");
  abs(valLG-val)
  disp("LaGrange relative error");
  abs(valLG-val)/abs(val)
endfunction
