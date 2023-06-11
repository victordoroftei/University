function LX=lagrange_bary(x,f,X,type='none')
  w=coefs_bary(x,type);
  LX=X;
  for i=1:length(X)
    x_poz=find(X(i)==x);
    if isempty(x_poz)
      w_x=w./(X(i)-x);
      LX(i)=sum(w_x.*f)/sum(w_x);
    else
      LX(i)=f(x_poz);
    endif
  endfor
endfunction
