function [L,U,P]=getLUP2(A)
  #descompunere LUP cu permutari fizice (se permuta efectiv liniile)
  [m,n]=size(A);
  P=zeros(m,n);
  piv=1:m;

  for i=1:m-1
      #pivotare
      [pm,kp]=max(abs(A(i:m,i)));
      if pm==0
        error("Nu avem solutie unica");
        return;
      endif
      kp=kp+i-1;

      #interschimbare
      if i~=kp
          A([i,kp],:)=A([kp,i],:);
          piv([i,kp])=piv([kp,i]);
      end

      #updatare (Schur)
      lin=i+1:m;
      A(lin,i)=A(lin,i)/A(i,i);
      A(lin,lin)=A(lin,lin)-A(lin,i)*A(i,lin);
  end;
  for i=1:m
      P(i,piv(i))=1;
  end;
  U=triu(A);
  L=tril(A,-1)+eye(m);
endfunction

