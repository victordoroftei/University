function p8b()
  syms x;

  f=exp(x);
  R11=my_pade_sym(f,1,1,x);
  R22=my_pade_sym(f,2,2,x);
  T2=taylor(f,'order',2);
  T4=taylor(f,'order',4);

  clf; hold on; grid on;
  a=-1;
  b=1;

  draw_sym_function(f,a,b);
  draw_sym_function(R11,a,b);
  draw_sym_function(R22,a,b);
  draw_sym_function(T2,a,b);
  draw_sym_function(T4,a,b);

  L={'f','R1,1','R2,2','T2','T4'};
  legend(L,'location','northeastoutside');
endfunction
