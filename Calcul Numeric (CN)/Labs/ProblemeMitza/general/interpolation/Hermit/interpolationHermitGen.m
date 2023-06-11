function HV=interpolationHermitGen(x,r,f,XV,XRV=0)
  #x - nodurile
  #r - multiplicitatile nodurilor
  #f - valorile functiei in noduri f{k}(i)=f derivat de k-1 ori (xi)
  #XV - punctele/simbolul in care se doreste polinomul
  #XRV - multiplicitatile pana la care se doreste derivata pentru fiecare X
  #HV - valorile polinomului si a derivatelor de ordin XR in X
  #HV{i}(k)=f derivat de k-1 ori in xi
  if length(XRV)==1
    XRV=XRV*ones(1,length(XV));
  endif

  c=interpolationDifDivGen(x,r,f)(1,:);
  z=repelem(x,r);
  m=length(z);

  HV={};
  for V_ind=1:length(XV)
    X=XV(V_ind);
    XR=XRV(V_ind);

    H=X*zeros(1,XR+1);
    P=cumprod([1 X-z(1:end-1)]);
    DP=P;
    H(1)=P*c';
    for k=1:XR
      DP(1:k)=0;

      for i=k+1:m
        DP(i)=DP(i-1)*(X-z(i-1))+k*P(i-1);
      endfor

      P=DP;
      H(k+1)=P*c';
    endfor

    HV{V_ind}=H;
  endfor
endfunction

