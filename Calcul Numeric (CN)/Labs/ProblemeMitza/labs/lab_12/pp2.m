function pp2()
  solveWithNewton();
  solveWithSuccesiv();
endfunction

function solveWithNewton()
  # toate astea ca sa avem function handle-urile...
  # ar putea fi calculate manual, dar dupa ar fi mai mult manual labor
  syms x y z;
  F=[9*x^2+36*y^2+4*z^2-36;
    x^2-2*y^2-20*z;
    x^2-y^2+z^2];
  J=jacobian(F);
  Fh=function_handle(F);
  Jh=function_handle(J);
  f=@(X) Fh(X(1),X(2),X(3));
  fd=@(X) Jh(X(1),X(2),X(3));

  disp("Newton");
  [alfa,val_f,i]=solveNewton(f,fd,[-1;-1;0])
  [alfa,val_f,i]=solveNewton(f,fd,[-1;1;0])
  [alfa,val_f,i]=solveNewton(f,fd,[1;-1;0])
  [alfa,val_f,i]=solveNewton(f,fd,[1;1;0])
endfunction

function solveWithSuccesiv()
  # toate astea ca sa avem function handle-urile...
  # ar putea fi calculate manual, dar dupa ar fi mai mult manual labor
  syms x y z;
  F=[9*x^2+36*y^2+4*z^2-36;
    x^2-2*y^2-20*z;
    x^2-y^2+z^2];
  J=jacobian(F);
  Fh=function_handle(F);
  Jh=function_handle(J);
  f=@(X) Fh(X(1),X(2),X(3));
  fd=@(X) Jh(X(1),X(2),X(3));

  disp("Succesiv");
  x0=[-1;-1;0];
  [alfa,i]=solveSuccesiv(f_to_phi(f,fd,x0),x0)
  x0=[1;-1;0];
  [alfa,i]=solveSuccesiv(f_to_phi(f,fd,x0),x0)
  x0=[-1;1;0];
  [alfa,i]=solveSuccesiv(f_to_phi(f,fd,x0),x0)
  x0=[1;1;0];
  [alfa,i]=solveSuccesiv(f_to_phi(f,fd,x0),x0)
endfunction
