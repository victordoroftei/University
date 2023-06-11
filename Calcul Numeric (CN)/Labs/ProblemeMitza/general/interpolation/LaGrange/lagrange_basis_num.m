function basis_polys=lagrange_basis_num(x,XV)
  #x -> coordonatele x
  #XV -> punctele in care dorim polinoamele fundamentale
  #basis_polys(k,c)=lk(XV(c))
  #full_polys(c)=(XV(c)-x0)...(XV(c)-xm)
  n=length(XV);
  m=length(x);
  basis_polys=zeros(m,n);

  differences=x-x';
  denoms=prod(differences+eye(m));

  #cred ca poate fi eficientizat, dar asta la costul preciziei?
  for c=1:n
    X=XV(c);
    numers=X-x;
    for k=1:m
      oldV=numers(k);
      numers(k)=1;

      numers_prod=prod(numers);
      basis_polys(k,c)=numers_prod/denoms(k);

      numers(k)=oldV;
    endfor
  endfor
endfunction

