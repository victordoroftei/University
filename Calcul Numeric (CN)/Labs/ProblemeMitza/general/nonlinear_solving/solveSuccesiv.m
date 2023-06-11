function [x1,i]=solveSuccesiv(phi,x0,err=1e-12,NrMaxIt=100)
  # f must be [f1;f2;...;fn] (column)
  # x0 must be [v1;v2;....;vm] (column)
  for i=1:NrMaxIt
    x1=phi(x0);
    if norm(x1-x0,Inf)<err||norm(x1-x0,Inf)/norm(x1,Inf)<err
      return;
    end
    x0=x1;
  endfor
endfunction
