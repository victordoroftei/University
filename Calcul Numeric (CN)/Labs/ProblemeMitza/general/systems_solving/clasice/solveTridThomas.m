function x=solveTridThomas(a,b,c,d)
  # toti vectorii ar trebui sa aiba dimensiune n,n>=2
  # a(k),b(k),c(k),d(k),x(k) -> valorile ce corepund liniei k
  # a -> diag -1
  # b -> diag 0
  # c -> diag 1
  # d -> termenii liberi
  # x -> solutia
  n=length(d);
  x=zeros(n,1);

  c(1)=c(1)/b(1);
  for i=2:n-1
    c(i)=c(i)/(b(i)-a(i)*c(i-1));
  endfor
  d(1)=d(1)/b(1);
  for i=2:n
    d(i)=(d(i)-a(i)*d(i-1))/(b(i)-a(i)*c(i-1));
  endfor
  x(n)=d(n);
  for i=n-1:-1:1
    x(i)=d(i)-c(i)*x(i+1);
  endfor
endfunction
