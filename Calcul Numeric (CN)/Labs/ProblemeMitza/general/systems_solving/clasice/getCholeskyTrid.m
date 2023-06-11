function [r1,r2]=getCholeskyTrid(v1,v2)
  #calculeaza matricea R din descompunerea Cholesky
  #pentru matrice tridiagonala unde v1 este diagonala principala
  #si v2 este diagonala de sub diagonala principala
  n=length(v1);
  for k=1:n
    if v1(k)<=0
      error("Matricea nu e HPD");
    endif
    if k!=n
      v1(k+1)=v1(k+1)-v2(k)*v2(k)/v1(k);
    endif
    v1_sqrt=sqrt(v1(k));
    v1(k)=v1(k)/v1_sqrt;
    if k!=n
      v2(k)=v2(k)/v1_sqrt;
    endif
  endfor
  r1=v1;
  r2=v2;
endfunction
