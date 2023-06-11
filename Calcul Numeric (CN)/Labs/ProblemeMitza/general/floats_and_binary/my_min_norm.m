function x=my_min_norm(myone=double(1))
  #myone reprezinta unitatea reprezentarii
  #ex: 'single(1)' - daca vrei single/float, 'double(1)' - daca vrei double
  x=myone;
  my_eps=my_machine_epsilon(myone);
  #valoarea minima normalizata o sa fie de forma 1.00...0*2^p
  #o proprietate a nr. normalizate este ca x(1+eps) este in continuare
  #reprezentabil pe masina. asta inseamna ca putem verifica ca un nr. nu
  #este normalizat daca x(1+eps)=x.
  #astfel, incepem de la 1 si tot impartim la 2, si ne oprim cu un pas inainte
  #ca x(1+eps)=x
  while x!=x+x*my_eps
    x=x/2;
  endwhile
  x=x*2;
endfunction

