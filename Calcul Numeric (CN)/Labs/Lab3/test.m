function t=test()
  k=1:20;
  xi=2.^(-k);
  p=poly(xi);
  nc=zeros(1,20)
  for i=1:20
    nc(i)=condpol(p,xi(i));
  endfor
  [xi' nc']
endfunction
