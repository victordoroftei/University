function [x,ni,rho]=solveIterJacobi(A,b,nr_max_it=1e+4,err=1e-14,p=Inf)
  M=diag(diag(A));
  [x,ni,rho]=solveIter(A,b,M,nr_max_it,err,p);
endfunction
