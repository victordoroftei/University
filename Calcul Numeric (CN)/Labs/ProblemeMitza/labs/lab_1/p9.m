function p9()
  #ar trebui si pe hartie
  syms x

  f=besselj(0,2*x);
  R31=my_pade_sym(f,3,1,x);
  R43=my_pade_sym(f,4,3,x);
  R24=my_pade_sym(f,2,4,x);
  T10=taylor(f,'order',10);

  clf; hold on; grid on;
  a=-1;
  b=1;

  draw_sym_function(f,a,b);
  draw_sym_function(R31,a,b);
  draw_sym_function(R43,a,b);
  draw_sym_function(R24,a,b);
  draw_sym_function(T10,a,b);

  L={'f','R3,1','R4,3','R2,4','T10'};
  legend(L,'location','northeastoutside');

  #ca sa calculezi seria pentru BesselJ0 pe hartie:
  #incepem cu seria pentru cos(x). inlocuim pe x cu xsin(theta).
  #acum avem o serie pentru cos(xsin(theta)). integram de la 0 la pi cu respect
  #la theta. acum avem integrala de la 0 la pi din cos(xsin(theta)). acum
  #termenii seriei o sa arate ceva de genul x^2k / (2k!) * integrala din
  #sin^(2k). mai trebuie calculata integrala din sin^(2k) si totul va fi ok.
  #ca sa calculam integralele acestea, se poate calcula de mana pentru fiecare
  #termen, sau se poate gasi o formula generala (exista, dar cred ca era mai
  #greu de gasit). acum, daca inmultim seria ce o avem acum cu cu 1/pi, avem
  #seria pntru functia BesselJ0.
endfunction
