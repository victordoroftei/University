function L=interpolationNewton(x,f,X)
  c=interpolationDifDiv(x,f)(1,:);
  n=length(X);

  cp=cumprod([ones(1,n); X-x(1:end-1)']);
  L=c*cp;

  #{
  L=zeros(1,n);
  for k=1:n
    p=1;
    for i=1:length(c)
      L(k)+=c(i)*p;
      p*=X(k)-x(i);
    endfor
  endfor
  #}
endfunction

