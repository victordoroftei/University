function x=my_machine_epsilon(myone=double(1))
  #myone reprezinta unitatea reprezentarii
  #ex: 'single(1)' - daca vrei single/float, 'double(1)' - daca vrei double
  x=abs(myone-(4/3-myone)*3);
  #in general pentru baza beta e asta (dar merge doar daca aveti procesor
  #in baza beta)
  #v1=beta^2-1
  #v2=beta^2-1+beta-1
  #abs(myone-(v1/v2-myone)*v2)
endfunction

