function y=my_better_sin_pade(x,m=10,k=10,digits=1144)
  #x - nr. pentru care calculam
  #m,k - rank-ul aproximarii pade aplicate
  #digits - nr. de cifre cu care il consideram pe x la reducerea la [0;2pi)
  x=reducereper(x,digits,use_vpa);
  semn=1;
  if x>3*pi/2
    x=2*pi-x; semn=-1;
  elseif x>pi
    x=x-pi; semn=-1;
  elseif x>pi/2
    x=pi-x;
  endif
  if x<=pi/4
    y=my_sin_pade(x,m,k);
  else
    y=my_cos_pade(pi/2-x,m,k);
  endif
  y=semn*y;
endfunction
