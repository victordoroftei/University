function coefs=pade_taylor_coefs(f,n,x)
  #returneaza coeficientii taylor cu indicii 0,1,2,...,n
  #f - functia de intrare (simbolica)
  #n - gradul
  #x - simbolul functiei
  #asta in contextul aproximarii Pade, deci mereu centrat in a=0
  #termenul cu indicele i este de forma fdi(0)*(x^i)/i!, un fdi este a i-a
  #derivata. pentru noi, coeficientul este reprezentat strict de fdi(a)/i!

  coefs=sym(zeros(1,n+1)); #avem n+1 elemente

  #fdi este cea de-a i-a derivata
  fdi=f;
  #termi este 1/i!
  termi=sym(1);

  #putem obtine al i-lea coeficient al seriei inmultind termi cu fdi(0)
  #adica, fdi(0)/ i!
  for i=0:n
    #coeficientul cu nr. i este f derivat de i ori *x^i /i!
    coefs(i+1)=subs(fdi,x,0)*termi; #indexare de la 0...
    #actualizam termenii
    fdi=diff(fdi,x,1); #derivam o data fdi ca sa avem a i+1 derivata
    termi=termi/(i+1);
  endfor
endfunction
