function x=my_max_norm(myone=double(1))
  #myone reprezinta unitatea reprezentarii
  #ex: 'single(1)' - daca vrei single/float, 'double(1)' - daca vrei double
  x=2*myone;
  x=x-my_machine_epsilon(myone);
  #ce am facut e astfel (ne prefacem ca avem precizie=3 (3 zecimale binare):
  #1 = 1.000 * 2^0
  #2 = 1.000 * 2^1
  #eps=0.001 * 2^0 = 0.0001 *2^1
  #2-eps = 1.0000 * 2^1 - 0.0001 * 2^1 = 0.1111* 2^1 = 1.111 * 2^0
  #am facut asta pentru ca doream sa obtinem 1.111....1 *2^ceva
  #deoarece asa arata valoarea maxima
  #tot ce mai trebuie sa facem este sa tot shiftam (adica sa inmultim cu 2)
  #pana ajungem la infinit
  #!!! ne oprim INAINTE de infinit
  while x*2!=inf
    x=x*2;
  endwhile
endfunction

