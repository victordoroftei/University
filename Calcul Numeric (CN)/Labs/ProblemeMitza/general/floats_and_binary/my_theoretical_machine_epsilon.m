function x=my_theoretical_machine_epsilon(myone=double(1))
  #myone reprezinta unitatea reprezentarii
  #ex: 'single(1)' - daca vrei single/float, 'double(1)' - daca vrei double
  x=my_machine_epsilon(myone)/2;
endfunction
