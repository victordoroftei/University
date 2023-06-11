function arie=romberg(f,a,b,n)
  T=romberg_table(f,a,b,n);
  arie=T(n,n);
endfunction
