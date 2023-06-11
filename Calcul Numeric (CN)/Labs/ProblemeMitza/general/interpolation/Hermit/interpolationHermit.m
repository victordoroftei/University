function [H,DH]=interpolationHermit(x,f,df,X)
  c=interpolationDoubleDifDiv(x,f,df)(1,:);
  z=repelem(x,2);
  n=length(X);
  m=length(z);

  cp=cumprod([ones(1,n); X-z(1:end-1)']);
  H=c*cp;

  if nargout>1
    DP=cp;
    DP(1,:)=zeros(1,n);
    for k=2:m
      DP(k,:)=DP(k-1,:).*(X-z(k-1))+cp(k-1,:);
    endfor
    DH=c*DP;
  endif
  #{
  H=zeros(1,n);
  DH=zeros(1,n);
  for k=1:n
    p=1;
    DP=0;
    for i=1:m
      H(k)+=c(i)*p;
      DH(k)+=c(i)*DP;
      DP=DP*(X(k)-z(i))+p;
      p*=X(k)-z(i);
    endfor
  endfor
  #}
endfunction

