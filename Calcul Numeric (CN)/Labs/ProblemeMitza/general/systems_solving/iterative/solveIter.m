function [x,ni,rho]=solveIter(A,b,M,nr_max_it=1e+4,err=1e-14,p=Inf)
  #M trebuie sa fie inversabila

  N=M-A;T=M\N;c=M\b;
  rho=max(abs(eig(T))); #raza spectrala
  if rho>=1
    error('Raza spectrala nu e mai mica ca 1 -> metoda nu va converge');
  endif

  norm_T=norm(T,p);
  can_apply_error=norm_T<1;
  if !can_apply_error
    disp('norm(T,p) nu e mai mica ca 1, alegeti un alt p');
    disp('programul va fi efectuat ignorand eroarea propusa si realizand toate iteratiile');
  else
    factor=norm_T/(1-norm_T);
  endif

  x_old=zeros(size(b)); ni=1;
  x=x_old;
  while ni<nr_max_it
    x=T*x+c;
    if can_apply_error && factor*norm(x-x_old,p)<err
      return;
    else
      x_old=x;
      ni=ni+1;
    endif
  endwhile
endfunction
