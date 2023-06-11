function rez=my_sin_pade(val,m=10,k=10)
  syms x;
  sinPade=function_handle(my_pade_sym(sin(x),m,k,x));
  rez=sinPade(val);
endfunction
