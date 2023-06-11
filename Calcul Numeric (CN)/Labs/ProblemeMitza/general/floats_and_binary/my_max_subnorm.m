function x=my_max_subnorm(myone=double(1))
  #myone reprezinta unitatea reprezentarii
  #ex: 'single(1)' - daca vrei single/float, 'double(1)' - daca vrei double
  my_eps=my_machine_epsilon(myone);
  #valoarea maxima subnormalizata va fi vecinul inferior al valorii minime
  #normalizate
  x=my_min_norm(myone);
  #x este inceput de interval ([x;2*x), pentru ca x e putere a lui)
  #ca sa trecem la nr. imediat inainte de x, vom vrea pasul de la intervalul
  #[x/2;x). pasul ar fi atunci (x/2)*eps (pentru intervalul [x;2x), pasul este
  #eps*x). doar ca asta ar fi fost valabil daca x/2 e normalizat. cum e
  #subnormalizat, putem reprezenta mai putine numere pe [x/2;x). asa ca pasul
  #va fi mai mare (daca pasul e mai mare, parcurg mai rapid intervalul si sar
  #anumite numere). mai exact, pasul se dubleaza. deci vom scade (x/2)*eps*2
  #care este de fapt x*eps
  x=x-x*my_eps;
endfunction
