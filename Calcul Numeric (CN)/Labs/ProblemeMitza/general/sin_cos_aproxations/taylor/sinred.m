function ssin=sinred(x)
  ssin=0;
  u=x;
  n=0;
  while u!=0
    ssin=ssin+u;
    n++;
    u=u*(-1)*((x*x)/((2*n)*(2*n+1)));
  endwhile
endfunction
