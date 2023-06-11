function [x1,x2]=solve_quadratic(a,b,c)
  if b==0
    x1=sqrt(-c/a);
    x2=-x1;
  else
    my_delta=sqrt(b^2-4*a*c);
    if b>0
      x1=(2*c)/(-b-my_delta);
      x2=(-b-my_delta)/(2*a);
    else
      x1=(-b+my_delta)/(2*a);
      x2=(2*c)/(-b+my_delta);
    endif
  endif
endfunction
