function p1()
  f=@(x) cos(x)-x;
  fd=@(x) -sin(x)-1;
  phi=@(x) cos(x);

  disp("Newton");
  [alfa,val_f,i]=solveNewton(f,fd,pi/4)
  disp("secanta");
  [alfa,val_f,i]=solveSecant(f,0,pi/2)
  disp("Steffensen");
  [alfa,i]=solveSteffensen(phi,pi/4)
  disp("succesiv");
  [alfa,i]=solveSuccesiv(phi,pi/4)
endfunction
