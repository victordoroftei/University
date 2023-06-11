function p2_a()
  for n=10:15
    Vn=ones(n);
    for i=2:n
      for j=1:n
        Vn(i,j)=Vn(i-1,j)*(-1+j*2/n);
      endfor
    endfor
    n
    cond(Vn,Inf)
  endfor
endfunction
