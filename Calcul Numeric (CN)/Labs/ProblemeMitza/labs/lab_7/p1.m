function p1()
  x=[0 3];
  f=@(x) x.^2-3;
  df=@(x) 2*x;
  X=[2,3];

  [H,DH]=interpolationHermit(x,f(x),df(x),X)
  syms X
  [H,DH]=interpolationHermit(x,f(x),df(x),X)
endfunction
