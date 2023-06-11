function T=interpolationDifDivGen(x,r,f)
  #x -> nodurile
  #r -> multiplicitatile nodurilor
  #f -> valorile functiei si derivatelor in noduri
  #f{1,k}(i)=f derivat de k-1 ori (xi)
  #returneaza tabelul de diferente divizate cu noduri generice
  n=sum(r);
  nrX=length(x);
  T=NaN(n);

  z=repelem(x,r);
  T(:,1)=repelem(f{1,1},r);

  indices=1:n;
  p=1;
  for k=2:n
    indices=indices(1:end-1);

    T(indices,k)=T(indices+1,k-1)-T(indices,k-1);
    T(indices,k)=T(indices,k)./(z(indices+k-1)-z(indices))';
    ind_replace=find(k<=r);
    p=p*(k-1);
    for ind=ind_replace
      st=sum(r(1:ind-1))+1;
      dr=st+r(ind)-k;
      T(st:dr,k)=f{k}(ind)/p;
    endfor
  endfor
endfunction

