function x=solveSOR(A,b,omega,nr_it=100)
  # metoda doar aplica SOR de nr_it ori, nu garanteaza si ca converge
  n=length(b);
  x=zeros(n,1);
  x_old=x;
  for k=1:nr_it
    for i=1:n
      x(i)=omega/A(i,i)*(b(i)-A(i,1:i-1)*x(1:i-1)-A(i,i+1:n)*x_old(i+1:n))+(1-omega)*x_old(i);
    endfor
    x_old=x;
  endfor
endfunction
