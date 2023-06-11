function p10()
  syms x;

  f1=exp(x);
  [f1T,f1R]=taylor_sym(f1,x,0,5);
  f1T
  f1R

  f2=log(1+x);
  [f2T,f2R]=taylor_sym(f2,x,0,5);
  f2T
  f2R
endfunction
