function R=getCholesky(A)
  #calculeaza matricea R din descompunerea Cholesky
  #pentru o matrice A ce este HPD
  #R triunghiulara superior
  [m,n]=size(A);
  for k=1:m
      if A(k,k)<=0
          error("Matricea nu e HPD");
      endif
      for j=k+1:m
          A(j,j:m)=A(j,j:m)-A(k,j:m)*A(k,j)/A(k,k);
      endfor
      A(k,k:m)=A(k,k:m)/sqrt(A(k,k));
  endfor
  R=triu(A);
endfunction
