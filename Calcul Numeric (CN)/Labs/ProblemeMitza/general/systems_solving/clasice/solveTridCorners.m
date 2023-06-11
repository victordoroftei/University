function x=solveTridCorners(a,b,c,d)
  # rezolva un sistem tridiagonal ce are si colturile nenule
  # toti vectorii ar trebui sa aiba dimensiune n,n>=3
  # a(k),b(k),c(k),d(k),x(k) -> valorile ce corepund liniei k
  # a -> diag -1
  # b -> diag 0
  # c -> diag 1
  # d -> termenii liberi
  # x -> solutia
  n=length(d);
  x=zeros(n,1);

  for i=2:n-1
    f=a(i)/b(i-1);
    if i!=n-1
      a(i)=-a(i-1)*f;
    else
      a(i)=c(i)-a(i-1)*f;
    endif
    b(i)=b(i)-c(i-1)*f;
    d(i)=d(i)-d(i-1)*f;
  endfor
  for i=n-2:-1:1
    f=c(i)/b(i+1);
    a(i)=a(i)-a(i+1)*f;
    d(i)=d(i)-d(i+1)*f;
  endfor

  f=c(n)/b(1);
  b(n)=b(n)-a(1)*f;d(n)=d(n)-d(1)*f;
  f=a(n)/b(n-1);
  b(n)=b(n)-a(n-1)*f;d(n)=d(n)-d(n-1)*f;

  x(n)=d(n)/b(n);
  x(1:n-1)=(d(1:n-1)-x(n)*a(1:n-1))./b(1:n-1);
endfunction
