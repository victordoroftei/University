function p7()
  syms x;

  #totul se executa fara pauza, deci graficul pentru f1 o sa dispara cand e gata
  #daca vrei sa vezi graficul pentru f1 mai bine, doar comenteaza ultimul apel
  #de taylor_draw

  f1=exp(x);
  taylor_draw(f1,x,-1,3,5);

  f2=log(1+x);
  taylor_draw(f2,x,-1,1,5);
endfunction
