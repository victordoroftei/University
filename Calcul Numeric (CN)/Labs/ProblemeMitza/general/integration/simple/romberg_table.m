function T=romberg_table(f,a,b,n)
  T=NaN(n);
  for i=1:n
    T(i,1)=rep_trapez(f,a,b,2^(i-1));
    for j=2:i
      fj=4^(-j+1);
      T(i,j)=(fj*T(i-1,j-1)-T(i,j-1))/(fj-1);
    endfor
  endfor
endfunction
