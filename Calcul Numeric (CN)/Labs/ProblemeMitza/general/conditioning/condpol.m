function nr_cond=condpol(coefs,xi)
  #coefs - coeficientii polinomului
  #xi - radacinile
  #daca xi(k) nu este radacina simpla, comportamentul este undefined
  coefs_der=polyder(coefs); %coef. derivatei lui p;
  nr_cond=polyval(abs(coefs(2:end)),abs(xi))./abs(xi.*polyval(coefs_der,xi));
  #nr_cond=polyval(abs(coefs(2:end)),abs(xi))/abs(xi*polyval(coefs_der,xi));
endfunction
