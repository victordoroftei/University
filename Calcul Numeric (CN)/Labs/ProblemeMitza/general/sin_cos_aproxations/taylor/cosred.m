function ccos=cosred(x)
  ccos=0;
  u=1;
  n=0;
  while u!=0
    ccos=ccos+u;
    n++;
    u=u*(-1)*((x*x)/((2*n-1)*(2*n)));
  endwhile
endfunction
