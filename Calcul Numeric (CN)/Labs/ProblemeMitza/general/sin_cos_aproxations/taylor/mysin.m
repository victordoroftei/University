function y=mysin(x,digits=1144)
  x=reducereper(x,digits);
  semn=1;
  if x>3*pi/2
    x=2*pi-x; semn=-1;
  elseif x>pi
    x=x-pi; semn=-1;
  elseif x>pi/2
    x=pi-x;
  endif
  if x<=pi/4
    y=sinred(x);
  else
    y=cosred(pi/2-x);
  endif
  y=semn*y;
endfunction
