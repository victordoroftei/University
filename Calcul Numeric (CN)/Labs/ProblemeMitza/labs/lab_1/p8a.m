function R=p8a()
  syms x

  f=exp(x)
  m=5
  k=4

  R=my_pade_sym(f,m,k,x)
endfunction
