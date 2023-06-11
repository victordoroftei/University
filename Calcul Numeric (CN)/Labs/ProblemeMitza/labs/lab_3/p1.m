function p1()
  Hn=zeros(9,9);
  for i=1:15
    for j=1:15
      Hn(i,j)=1/(i+j-1);
    endfor
  endfor
  for n=10:15
    n
    cond(Hn(1:n,1:n),2)
  endfor
endfunction
