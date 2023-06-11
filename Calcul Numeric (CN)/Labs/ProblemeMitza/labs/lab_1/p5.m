function p5()
  #ar trebui si pe hartie
  syms x;

  f1=log(1+x);
  taylorf1=taylor(f1,'order',9);

  rez1=subs(taylorf1,1);
  disp "Calculated 1"
  double(rez1)

  f2=log((1+x)/(1-x));
  taylorf2=taylor(f2,'order',9);

  rez2=subs(taylorf2,sym(1)/3);
  disp "Calculated 2"
  double(rez2)

  val = log(2);
  disp("Actual");
  double(val)

  #pentru calculele de mana
  #seria lui ln(1+x):
  #pornim de la seria lui 1/(1-t). Inlocuim pe t cu (-t) - acum avem seria
  #pentru 1/(1+t).integram functia de la 0 la x - rezultatul va fi seria
  #pentru ln(1+x).
  #pentru ln((1+x)/(1-x)) = ln(1+x)-ln(1-x).
  #stim seria pentru ln(1+x).
  #inlocuim in seria lui ln(1+x) pe x cu -x, si obtinem seria pentru ln(1-x).
  #facem diferenta seriilor ln(1+x) si ln(1-x), si obtinem seria cautata
endfunction
