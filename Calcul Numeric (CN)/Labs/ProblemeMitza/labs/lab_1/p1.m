function p1()
  #ar trebui si pe hartie
  syms x a;

  f=sqrt(a+x)
  #aveam nevoie si de functia restului asa ca am apelat metoda taylor_sym
  [taylorf,restf]=taylor_sym(f,x,0,10)
  #taylor(f,x,0,'order',10+1)

  #rezolvare de mana in pdf cu cerinte
endfunction
