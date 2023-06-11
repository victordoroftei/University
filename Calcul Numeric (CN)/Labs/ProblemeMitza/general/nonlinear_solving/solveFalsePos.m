function [c,val_f,i]=solveFalsePos(f,a,b,err=1e-12,NrMaxIt=100)
  for i=1:NrMaxIt
    c=(a*f(b)-b*f(a))/(f(b)-f(a));
    if abs(f(c))<err||abs(a-b)<err||abs(a-b)/abs(c)<err
      val_f=f(c);
      return;
    end
    if f(a)*f(c)<0
      b=c;
    else
      a=c;
    endif
  endfor
endfunction
