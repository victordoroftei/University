function [A,b]=getGaussElim(A,b)
  #aplica eliminare Gaussiana pe un sistem Ax=b si returneaza matricile A,b
  #rezultate

  A=[A b];
  n=length(b);
  for k=1:n-1
    [valmax,pozmax]=max(abs(A(k:end,k)));
    pozpivot=pozmax+k-1;
    if valmax==0
      error("Nu avem solutie unica");
      return;
    elseif pozpivot!=k
      A([k,pozpivot],k:end)=A([pozpivot,k],k:end);
    endif
    for i=k+1:n
      A(i,k:end)=A(i,k:end)-A(k,k:end)*A(i,k)/A(k,k);
    endfor
  endfor

  b=A(:,end);
  A=A(:,1:end-1);
endfunction
