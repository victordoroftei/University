function p6()
  #ar trebui si pe hartie
  syms x;

  f=atan(x);
  [taylorf,restf]=taylor_sym(f,x,0,10)

  val=subs(taylorf,1);
  disp("Calculated");
  double(val)

  val = pi/4;
  disp("Actual");
  double(val)

  #pentru a calcula de mana seria pentru arctangenta:
  #incepem de la seria lui 1/(1-t). Inlocuim pe t cu -t^2.
  #acum avem seria lui 1/(1+t^2). Integram de la 0 la x.
  #obtinem seria pentru arctg(x).
  #pentru rest. seria va fi alternanta, deci eroarea va fi mai mica in
  #modul ca ultimul termen neglijat din serie (daca ne-am oprit la termenul 10,
  #eroarea va fi mai mica ca termenul 11). deci vom lua Rn (Restul de ordin n),
  #si zicem ca este mai mic in modul ca termenul de ordin n+1
  #deci, ca sa atingem precizia de 5 zecimale, ar trebui sa impunem conditia ca
  #termenul n+1 este mai mic ca 10^(-5), de unde il putem afla pe n
endfunction
