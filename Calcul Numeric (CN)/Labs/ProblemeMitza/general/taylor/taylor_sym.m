function [T,R]=taylor_sym(f,x,theta,a,n)
  #calculeaza polinomul Taylor si restul LaGrange de ordin n
  #f - functia simbolica
  #x - simbolul functiei f
  #theta - simbol folosit in rest,
  #a - punctul in care se dezvolta polinomul taylor
  #n - gradul polinomului

  #taylor() din octave necesita apelul cu n+1 pentru ordinul n, asta n-are
  #nevoie (merge direct cu n)

  #T este polinomul Taylor final, R este restul final
  T=sym(0);
  R=sym(0);

  #fdi este cea de-a i-a derivata
  fdi=f;
  #termi este (x-a)^(i)/i!
  termi=sym(1);

  #putem obtine al i-lea termen al seriei inmultind termi cu fdi(a)
  #adica, term i+1 = fdi(a)*term i (= fdi(a) *(x-a)^i / i!)

  for i=0:n
    #termnul cu nr. i este f derivat de i ori *(x-a)^i /i!
    new_term=subs(fdi,x,a)*termi;
    T=T+new_term;
    #actualizam termenii
    fdi=diff(fdi,x,1); #derivam o data fdi ca sa avem a i+1 derivata
    termi=termi*(x-a)/(i+1);
  endfor

  #aici e formula pentru restul LaGrange, aplicat direct.
  #acum, practic i-ul este n+1, deci
  R=subs(fdi,x,a+(x-a)*theta)*termi;
endfunction
