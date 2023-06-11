function pp1()
  f=@(x) [x(1)^2+x(2)^2-1;x(1)^3-x(2)];
  fd=@(x) [2*x(1),2*x(2);3*x(1)^2,-1];

  disp("Newton");
  [alfa,val_f,i]=solveNewton(f,fd,[sqrt(2);sqrt(2)])
endfunction
