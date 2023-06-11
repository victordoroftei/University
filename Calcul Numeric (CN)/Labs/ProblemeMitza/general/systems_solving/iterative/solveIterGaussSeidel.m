function [x,ni,rho]=solveIterGaussSeidel(A,b,nr_max_it=1e+4,err=1e-14,p=Inf)
  #M=diag(diag(A))+tril(A,-1);
  M=tril(A);
  [x,ni,rho]=solveIter(A,b,M,nr_max_it,err,p);
endfunction
