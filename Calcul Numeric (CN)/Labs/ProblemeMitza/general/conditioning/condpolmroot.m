function nr_cond=condpolmroot(coefs,xi,ord)
  # coefs - coeficientii polinomului
  # xi - radacinile
  # ord - ordinul radacinilor
  # daca xi(k) nu este radacina de ordin ord(k), comportamentul este undefined
  nr_cond=[];

  n=length(xi);
  for i=1:n
    m=ord(i);
    rad=xi(i);

    coefs_der=coefs;
    for k=1:m
      coefs_der=polyder(coefs_der);
    endfor

    new_cond=factorial(m)*polyval(abs(coefs),abs(rad));
    new_cond=new_cond/abs(rad*polyval(coefs_der,rad));
    new_cond=new_cond^(1/m);
    new_cond=new_cond*eps^(1/m-1);
    nr_cond=[nr_cond new_cond];
  endfor
endfunction
