function arie=adapt_quad(method,f,a,b,err,m=4)
  arie1=method(f,a,b,m);
  arie2=method(f,a,b,2*m);
  if abs(arie2-arie1)<err
    arie=arie2;
  else
    mij=(a+b)/2;
    it1=adapt_quad(method,f,a,mij,err,m);
    it2=adapt_quad(method,f,mij,b,err,m);
    arie=it1+it2;
  endif
endfunction
