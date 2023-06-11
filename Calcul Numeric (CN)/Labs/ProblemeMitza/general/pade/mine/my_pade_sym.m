function R=my_pade_sym(f,m,k,x)
  # f - functia pentru care dorim aproximarea Pade
  # m - gradul polinomului de sus
  # k - gradul polinomului de jos
  # x - simbolul functiei (cum ar fi, f(t)= e^t, x va fi t)
  if k==0
    R=taylor(f,'order',m+1);
  else
    taylor_coefs=pade_taylor_coefs(f,m+k,x);

    c=taylor_coefs(m+1:m+k-1+1);

    r=sym(zeros(1,k));
    r_negative_indices=abs(min([0,m-k+1])); #numarul de indici negativi
    r(1:k-r_negative_indices)=taylor_coefs(m+1:-1:m-k+1+1+r_negative_indices);

    d=-taylor_coefs(m+1+1:m+k+1);

    C=toeplitz(c,r);
    k=rank(C);

    if k==0
      R=taylor(f,'order',m+1);
    else
      C=C(1:k,1:k);
      d=d(1:k);
      b=C\d';
      b=[1; b];
      a=sym(zeros(m+1,1));
      for j=0:m
        for l=0:min([j,k])
          a(j+1)=a(j+1)+taylor_coefs(j-l+1)*b(l+1);
        endfor
      endfor
      R=(x.^(0:m)*a)/(x.^(0:k)*b);
    endif
  endif
endfunction
