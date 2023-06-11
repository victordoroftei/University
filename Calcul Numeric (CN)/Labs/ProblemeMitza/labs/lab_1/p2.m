function p2()
  #ar trebui si pe hartie
  syms x;

  f=exp(x)
  #aveam nevoie specific de cum arata restul, asa ca am apelat taylor_sym
  [taylorf,restf]=taylor_sym(f,x,0,6)

  #rezolvare de mana in pdf cu cerinte
endfunction
