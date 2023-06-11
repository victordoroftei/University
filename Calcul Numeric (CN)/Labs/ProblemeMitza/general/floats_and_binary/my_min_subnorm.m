function x=my_min_subnorm(myone=double(1))
  #myone reprezinta unitatea reprezentarii
  #ex: 'single(1)' - daca vrei single/float, 'double(1)' - daca vrei double
  x=my_min_norm(myone)*my_machine_epsilon(myone);
end

