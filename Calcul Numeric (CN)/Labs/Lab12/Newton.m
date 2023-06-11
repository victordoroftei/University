function [x1,val_f,i]=Newton(f,df,x0,err=1e-12,NrMaxIt=100)
  for i=1:NrMaxIt
    x1=x0-df(x0)\f(x0);
    if norm(f(x1),Inf)<err||norm(x1-x0,Inf)<err...
      ||norm(x1-x0,Inf)/norm(x1,Inf)<err
      val_f=f(x1);
      return;
    end
    x0=x1;
  endfor
  val_f=f(x1);
endfunction