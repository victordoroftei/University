function y=mycos(x,digits=1144)
  x=reducereper(x,digits);
  semn=1;
  if x>3*pi/2
    x=2*pi-x;
  elseif x>pi
    x=x-pi; semn=-1;
  elseif x>pi/2
    x=pi-x; semn=-1;
  endif
  if x<=pi/4
    y=cosred(x);
  else
    y=sinred(pi/2-x);
  endif
  y=semn*y;
endfunction
