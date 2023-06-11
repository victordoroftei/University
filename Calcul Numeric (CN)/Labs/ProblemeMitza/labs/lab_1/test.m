function test()
  syms x;

  f=sqrt((1+x/2)/(1+2*x))
  R=pade_sym(f,1,1,x)
  T=taylor(f,'order',2+1)
  #TR=taylor(R,'order',2+1)

  clf; hold on; grid on;
  a=-0.4;
  b=1.4;

  draw_function(f,a,b);
  draw_function(R,a,b);
  draw_function(T,a,b);

  L={'f','R','T'};
  legend(L,'location','northeastoutside');
endfunction
