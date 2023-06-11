function [L,U,P,piv]=getLUP(A)
  #descompunere LUP cu permutari logice
  [m,n]=size(A);
  P=zeros(m,n);
  piv=1:m;

  for i=1:m-1
      #pivotare
      [pm,kp]=max(abs(A(piv(i:m),i)));
      if pm==0
        error("Nu avem solutie unica");
        return;
      endif
      kp=kp+i-1;

      #interschimbare
      if i~=kp
          piv([i,kp])=piv([kp,i]);
      endif

      #updatare (Schur)
      lin=i+1:m;
      A(piv(lin),i)=A(piv(lin),i)/A(piv(i),i);
      A(piv(lin),lin)=A(piv(lin),lin)-A(piv(lin),i)*A(piv(i),lin);
  endfor;
  for i=1:m
      P(i,piv(i))=1;
  endfor;
  U=triu(A(piv,:));
  L=tril(A(piv,:),-1)+eye(m);
endfunction

