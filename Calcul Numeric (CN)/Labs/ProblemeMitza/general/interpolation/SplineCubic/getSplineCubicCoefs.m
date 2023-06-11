function c=getSplineCubicCoefs(nodes,values,type,der_values)
  #c=the coefficients of the cubic spline of the given type
  #c(k,:)->coefs of pk (c1+c2*(x-x1)+c3*(x-x1)^2+c4*(x-x1)^3
  #'complete' <=> f'(a)=der_values(1), f'(b)=der_values(2)
  #'naturale' <=> f''(a)=0, f''(b)=0
  #'derivate2' <=> f''(a)=der_values(1),f''(b)=der_values(2)
  #'deBoor' <=> not-a-knot <=> p1=p2, pn-2=pn-1
  #'periodic' <=> f(a)=f(b),f'(a)=f'(b)
  n=length(nodes);
  c=zeros(n-1,4);
  dx=diff(nodes)'; ddiv=diff(values)'./dx;
  d1=zeros(n,1);d2=zeros(n,1);d3=zeros(n,1);
  b=zeros(n,1);

  switch type
    case 'periodice'
      if n==2
        c(1)=values(1);
        return;
      endif
  endswitch

  i=2:n-1;
  d1(i)=dx(i);
  d2(i)=2*(dx(i-1)+dx(i));
  d3(i)=dx(i-1);
  b(i)=3*(dx(i).*ddiv(i-1)+dx(i-1).*ddiv(i));

  switch type
    case 'complete'
      d2(1)=1;d2(n)=1;
      b(1)=der_values(1);b(n)=der_values(2);
    case 'naturale'
      d2(1)=2;d3(1)=1;
      d1(n)=1;d2(n)=2;
      b(1)=3*ddiv(1);b(n)=3*ddiv(n-1);
    case 'derivate2'
      d2(1)=2;d3(1)=1;
      d1(n)=1;d2(n)=2;
      b(1)=3*ddiv(1)-der_values(1)*dx(1)/2;
      b(n)=3*ddiv(n-1)+der_values(2)*dx(n-1)/2;
    case 'deBoor'
      d2(1)=dx(2);d3(1)=dx(2)+dx(1);
      d1(n)=dx(n-1)+dx(n-2);d2(n)=dx(n-2);
      b(1)=(ddiv(1)*dx(2)*(3*dx(1)+2*dx(2))+dx(1)*dx(1)*ddiv(2))/(dx(2)+dx(1));
      b(n)=(dx(n-1)*dx(n-1)*ddiv(n-2)+(3*dx(n-1)+2*dx(n-2))*dx(n-2)*ddiv(n-1))/(dx(n-1)+dx(n-2));
    case 'periodice'
      d2(1)=2*(dx(n-1)+dx(1));d3(1)=dx(n-1);d1(1)=dx(1);
      b(1)=3*(dx(1)*ddiv(n-1)+dx(n-1)*ddiv(1));
      if n==3
        d3(1)=d3(1)+d1(1);
        d3(2)=d3(1);
        d1(2)=d1(1);
      endif
  endswitch

  m=zeros(n,1);
  switch type
    case 'periodice'
      if n==3
        m(1:n-1)=solveTridThomas(d1(1:n-1),d2(1:n-1),d3(1:n-1),b(1:n-1));
        m(n)=m(1);
      else
        m(1:n-1)=solveTridCorners(d1(1:n-1),d2(1:n-1),d3(1:n-1),b(1:n-1));
        m(n)=m(1);
      endif
    otherwise
      m=solveTridThomas(d1,d2,d3,b);
  endswitch

  c(:,1)=values(1:n-1); c(:,2)=m(1:n-1);
  c(:,4)=(m(2:n)+m(1:n-1)-2*ddiv)./(dx.^2);
  c(:,3)=(ddiv-m(1:n-1))./dx-c(:,4).*dx;
endfunction
