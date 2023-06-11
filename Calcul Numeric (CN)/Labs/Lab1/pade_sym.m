function R=pade_sym(f, m, k, x)
  if k == 0
    R=taylor(f, 'order', m + 1);
  else
    c=sym(zeros(1, k)); # prima coloana din matricea Toeplitz
    r=c;  # primul rand din matricea Toeplitz
    d=c;  # matricea din dreapta
  for i = 0 : k - 1
    c(i+1)=taylor_coef(f, m + i, 0);
    r(i+1)=taylor_coef(f, m - i, 0);  # valorile c_m, c_m-1, ..., c_m-(k-1)
    d(i+1)=-taylor_coef(f, m + i + 1, 0); # valorile -c_m+1, -c_m+2, ..., -c_m+k
  endfor
    # noi trebuie sa aflam b-urile, rezolvand sistemul
   C=toeplitz(c,r);
   b=C\d';
   b=[1; b];
   a=sym(zeros(m+1,1));
  for j=0 : m
    for l=0:min([j,k])
      a(j+1)=a(j+1)+taylor_coef(f, j - l, 0)*b(l+1);  # a = sum(l, j) din c_(j-l) * b_l
    endfor
  endfor
   R=(x.^(0:m)*a)/(x.^(0:k)*b);
  endif
endfunction
