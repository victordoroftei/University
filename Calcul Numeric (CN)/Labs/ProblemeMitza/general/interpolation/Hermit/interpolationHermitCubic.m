function [H,DH]=interpolationHermitCubic(x,f,df,X)
  n=length(X);
  m=length(x);
  H=zeros(1,n);
  DH=H;
  [X,orderX]=sort(X);
  orderX(orderX)=1:length(orderX);

  pos=1;
  k=1;
  while pos<m && k<=n
    while X(k)<x(pos)
      pos++;
    endwhile
    start=k;
    while k<=n && X(k)<=x(pos+1)
      k++;
    endwhile
    k--;
    [H(start:k),DH(start:k)]=interpolationHermit(x(pos:pos+1),f(pos:pos+1),df(pos:pos+1),X(start:k));
    pos++;
	  k++;
  endwhile
  H=H(orderX);
  DH=DH(orderX);
endfunction

