function lmf=lagrange_aitken_sym(x,y,X)
  m=length(x);
  ait_tab=sym(y);
  for j=2:m
    ait_tab(j:end)=ait_tab(j-1)*(x(j:end)-X)-ait_tab(j:end)*(x(j-1)-X);
    ait_tab(j:end)=ait_tab(j:end)./(x(j:end)-x(j-1));
  endfor
  lmf=ait_tab(m);
endfunction
