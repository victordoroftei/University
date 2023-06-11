function rest_delims=interpolation_rest_fun(f,x,XV,points=500)
  #x -> punctele folosite pentru delimitare
  #XV -> punctele in care se doreste formula restului
  #theta -> valoarea derivate de ordin m sau simbolul aferent
  m=length(x);
  n=length(XV);

  f=sym(f);
  for k=1:m
    f=diff(f);
  endfor
  f=function_handle(f);

  M=zeros(1,n);
  for k=1:n
    X=XV(k);

    xk=[x X];
    a=min(xk);
    b=max(xk);
    interval=linspace(a,b,points);

    M(k)=max(abs(f(interval)));
  endfor

  rest_delims=abs(interpolation_rest(x,XV,M));
endfunction
