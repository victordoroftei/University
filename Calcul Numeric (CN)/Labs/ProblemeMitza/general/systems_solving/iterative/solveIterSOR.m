function [x,ni,rho]=solveIterSOR(A,b,omega=0,nr_max_it=1e+4,err=1e-14,p=Inf)
  #daca omega=0, se va lua omega=2/(1+sqrt(1-rhoJ^2)), unde rhoJ este raza
  #spectrala pentru T din metoda Jacobi, valoare ce corespunde solutiei optime
  #pentru A tridiagonal (
  #daca valoarea respectiva de omega nu este reala, se ia omega=1
  if omega==0
    MJ=diag(diag(A));NJ=MJ-A;TJ=MJ\NJ;
    rhoJ=max(abs(eig(TJ)));
    if rhoJ>1
      rhoJ=0
    endif
    omega=2/(1+sqrt(1-rhoJ^2));
  endif
  M=diag(diag(A))/omega+tril(A,-1);
  [x,ni,rho]=solveIter(A,b,M,nr_max_it,err,p);
endfunction
