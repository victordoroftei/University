function phi=f_to_phi(f,df,x0)
  phi=@(x) x-df(x0)\f(x);
endfunction
