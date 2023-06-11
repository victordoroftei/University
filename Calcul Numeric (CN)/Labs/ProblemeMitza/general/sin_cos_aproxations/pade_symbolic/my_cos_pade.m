function rez=my_cos_pade(val,m=10,k=10)
  syms x;
  cosPade=function_handle(my_pade_sym(cos(x),m,k,x));
  rez=cosPade(val);
endfunction
