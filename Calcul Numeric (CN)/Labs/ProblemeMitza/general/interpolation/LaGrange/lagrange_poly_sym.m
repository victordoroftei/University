function lmf=lagrange_poly_sym(x,y,X)
  #x -> coordonatele x
  #y -> coordonatele y
  #X -> simbolul variabilei functiei de output
  m=length(x);

  full_poly=prod(X-x);
  numers=full_poly./(X-x);

  differences=x-x';
  denoms=prod(differences+eye(m));
  #basis_polys(k) contine l(k-1)(X)
  basis_polys=numers./denoms;

  lmf=sum(basis_polys.*y);
endfunction
