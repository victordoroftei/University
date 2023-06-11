function p3()
  #comenteaza apelurile de desen de mai jos de care nu ai nevoie
  n=20;

  proots=1:n;
  p=poly(proots);
  nc=condpol(p,proots);
  [proots' nc']

  test_pol_disturbance(p);

  p=(2*ones(1,n+1)).^(0:-1:-n);
  proots=roots(p);
  nc=condpol(p,proots);
  [proots nc]

  test_pol_disturbance(p);
endfunction
