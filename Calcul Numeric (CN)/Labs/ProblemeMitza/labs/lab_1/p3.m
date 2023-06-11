function p3()
  #ar trebui si pe hartie
  syms x;

  f=(1+x)^(sym(1)/3);
  #vrem sa vedem cum arata inclusiv restul functiei
  [taylorf,restf]=taylor_sym(f,x,0,4)

  rez=10*subs(taylorf,x,-10^(sym(-3)));
  disp("Calculated");
  double(rez)

  val = (999)^(1/3);
  disp("Actual");
  double(val)

  #rezolvare de mana in pdf cu cerinte
endfunction
