function T=interpolationDifDiv(x,f)
  #returneaza tabelul de diferente divizate
  n=length(x);
  T=NaN(n);
  T(:,1)=f;
  indices=1:n;
  for k=2:n
    indices=indices(1:end-1);
    T(indices,k)=T(indices+1,k-1)-T(indices,k-1);
    T(indices,k)=T(indices,k)./(x(indices+k-1)-x(indices))';
  endfor
endfunction

