function p4()
  # formula generala pentru En e ceva de genul (nu-i complet corect)
  # En=(-1)^n*n!(suma de la k=0 la n din ((-1)^k/k!)-c)
  # daca dai in limita ai infinit * constanta. vrei constanta sa fie 0, altfel
  # ai limita +-infinit. deci 1/e=c

  # fie fn(c) o functie ce ne calculeaza E(n) cu E(0)=c
  # fn(c) = ceva+ (-1)^(n+1)*n!*c
  # fn'(c) = (-1)^(n+1)n!
  # (cond fn) (c) = |c|*n! /|fn(c)| =
  # |c|/(suma de la k=0 la n din ((-1)^k/k!)-c)
  # cand n tinde la infinit vom avea
  # |c|/|1/e-c|
  # pentru c=1/e, explodeaza la infinit

  # E(n+1) = 1 - (n+1)E(n)
  # E(n) = (1-E(n+1))/(n+1)
  # o luam de la n la 0
  n=101;
  En=0;
  for k=n:-1:1
    En=(1-En)/(k+1);
  endfor
  disp("Calculated");
  1/En
  disp("Actual");
  e
endfunction
