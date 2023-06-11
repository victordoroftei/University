function S=getSplineCubicEval(nodes,values,type,der_values,X)
  #der_values can be empty
  c=getSplineCubicCoefs(nodes,values,type,der_values);

  switch type
    case 'periodice'
      period=nodes(end)-nodes(1);
      X=nodes(1)+mod(X-nodes(1),period);
  endswitch
  [X,orderX]=sort(X);
  orderX(orderX)=1:length(orderX);
  m=length(nodes);
  n=length(X);
  S=zeros(1,n);
  pos=1;
  k=1;
  while pos<m && k<=n
    while X(k)<nodes(pos)
      pos++;
    endwhile
    start=k;
    while k<=n && X(k)<=nodes(pos+1)
      k++;
    endwhile
    k--;
    Xvals=X(start:k)-nodes(pos);
    S(start:k)=c(pos,1)+Xvals.*(c(pos,2)+Xvals.*(c(pos,3)+Xvals.*c(pos,4)));
    pos++;
	  k++;
  endwhile
  S=S(orderX);
endfunction
