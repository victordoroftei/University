function p2()
  f=@(x) [x(1)^2+x(2)^2-1;x(1)^3-x(2)];
  fd=@(x) [2*x(1),2*x(2);3*x(1)^2,-1];
  x0=[sqrt(2);sqrt(2)];
  phi=f_to_phi(f,fd,x0)

  disp("Newton");
  [alfa,val_f,i]=solveNewton(f,fd,x0)
  disp("Succesiv");
  [alfa,i]=solveSuccesiv(phi,x0)
endfunction
