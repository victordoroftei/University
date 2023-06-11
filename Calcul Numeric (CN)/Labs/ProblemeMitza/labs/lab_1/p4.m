function p4()
  #ar trebui si pe hartie
  syms x;

  f=exp(-x^2);               #e^(-x^2)
  taylorf=taylor(f,'order',10+1);  #e^(-x^2) dar ca taylor
  taylorf=int(taylorf);      #int integreaza functia(implicit de la 0 la x
                             #daca nu dai argumente)
                             #int de la 0 la x din e^(-t^2) dt
  taylorf=(sym(2)/sqrt(sym(pi)))*taylorf; # erf

  rez=subs(taylorf,1);
  disp("Calculated");
  double(rez)

  val = 0.8427;
  disp("Actual");
  double(val)

  #pentru a calcula de mana functia eroare, incepem de la seria lui
  #e^t. inlocuim t cu (-t^2). apoi, integram totul de la 0 la x
endfunction
