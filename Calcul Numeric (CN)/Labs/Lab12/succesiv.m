function [x1,i]=succesiv(phi,x0,err=1e-12,NrMaxIt=100)
for i=1:NrMaxIt
  x1=phi(x0);
  if norm(x1-x0,Inf)<err||norm(x1-x0,Inf)/norm(x1,Inf)<err
    return;
  end
  x0=x1;
endfor
endfunction