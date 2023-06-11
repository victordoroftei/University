function p2_b()
  for n=10:15
    Vn=ones(n);
    for i=2:n
      for j=1:n
        Vn(i,j)=Vn(i-1,j)*(1/j);
      endfor
    endfor
    n
    cond(Vn,Inf)
  endfor
endfunction
