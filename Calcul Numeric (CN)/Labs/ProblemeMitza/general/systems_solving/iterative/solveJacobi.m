function x=solveJacobi(A,b,nr_it=100)
  #metoda doar aplica Jacobi de nr_it ori, nu garanteaza si ca converge
  n=length(b);
  x=zeros(n,1);
  x_old=x;
  for k=1:nr_it
    diag_A=diag(A);
    #cred ca-s echivalente, dar pare ca e o eroare mai mare one-liner-ul
    #x=(1./diag_A).*(b-A*x_old+diag_A.*x_old);
    for i=1:n
      x(i)=1/A(i,i)*(b(i)-A(i,1:i-1)*x_old(1:i-1)-A(i,i+1:n)*x_old(i+1:n));
    endfor
    x_old=x;
  endfor
endfunction
