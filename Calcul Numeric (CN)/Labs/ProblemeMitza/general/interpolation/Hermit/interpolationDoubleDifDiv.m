function T=interpolationDoubleDifDiv(x,f,df)
  #returneaza tabelul de diferente divizate cu noduri duble
  n=2*length(x);
  T=NaN(n);
  T(:,1)=repelem(f,2);
  T(1:2:end-1,2)=df;
  T(2:2:end-2,2)=diff(f)./diff(x);
  z=repelem(x,2);
  indices=1:n-1;
  for k=3:n
    indices=indices(1:end-1);
    T(indices,k)=T(indices+1,k-1)-T(indices,k-1);
    T(indices,k)=T(indices,k)./(z(indices+k-1)-z(indices))';
  endfor
endfunction

