function x=solveGaussSeidel(A,b,nr_it=100)
  #metoda doar aplica GaussSeidel de nr_it ori, nu garanteaza si ca converge
  n=length(b);
  x=zeros(n,1);
  x_old=x;
  for k=1:nr_it
    for i=1:n
      x(i)=1/A(i,i)*(b(i)-A(i,1:i-1)*x(1:i-1)-A(i,i+1:n)*x_old(i+1:n));
    endfor
    x_old=x;
  endfor
endfunction
