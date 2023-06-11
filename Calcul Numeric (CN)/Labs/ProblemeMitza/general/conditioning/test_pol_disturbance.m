function test_pol_disturbance(coefs,dist_mean=0,std=1e-10)
  clf; hold on; grid on;

  #desenam radacinile originale
  proots=roots(coefs);
  h=plot(real(proots),imag(proots),'.');
  set(h,'Markersize',15);

  for k=1:1000
    new_coefs=coefs.*(1+normrnd(dist_mean,std,1,length(coefs)));
    #new_coefs=coefs.*(1+unifrnd(dist_mean-std,dist_mean+std,1,length(coefs)));
    new_roots=roots(new_coefs);
    h2=plot(real(new_roots),imag(new_roots),'k.');
    set(h2,'Markersize',4)
  endfor
  axis equal
endfunction
