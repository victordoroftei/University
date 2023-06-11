function arie=adapt_quad_simpson(f,a,b,err=eps,fa,fc,fb)
  if nargin!=7
    c=(a+b)/2;
    arie=adapt_quad_simpson(f,a,b,err,f(a),f(c),f(b));
    return;
  endif
  c=(a+b)/2;d=(a+c)/2;e=(c+b)/2;h=b-a;
  fd=f(d);fe=f(e);
  Q1=(fa+4*fc+fb)*h/6;
  Q2=(fa+4*fd+2*fc+4*fe+fb)*h/12;
  if abs(Q1-Q2)<err
    arie=Q2+(Q2-Q1)/15;
  else
    Qa=adapt_quad_simpson(f,a,c,err,fa,fd,fc);
    Qb=adapt_quad_simpson(f,c,b,err,fc,fe,fb);
    arie=Qa+Qb;
  endif
endfunction
