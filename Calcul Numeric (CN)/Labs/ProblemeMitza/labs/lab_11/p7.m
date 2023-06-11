function p7()
  # 1/sqrt(sin(x)) = 1/sin(x)^(1/2)= 1/(1-cos^2(x))^(1/4)
  # fie t=cos(x) => x=arccos(t) => dx = -1/sqrt(1-t^2) dt
  # I = integrala de la 1 la 0 din 1/(1-t^2)^(1/4) * (-1)/(1-t^2)^(1/2) dt
  # I = int de la 0 la 1 din (1-t^2)^(-3/4) dt
  # I = int de la -1 la 1 din (1/2)*(1-t^2)^(-3/4) dt
  # I = int de la 0 la 1 din (1/2)*(1-t)^(-3/4)*(1+t)^(-3/4) dt
  type='Jacobi';
  f=@(x) ones(length(x),1)/2;
  n=1;
  aa=-3/4;
  bb=-3/4;
  [I,nodes,coefs]=gauss_quad_num(type,f,n,aa,bb);
  I
  quad(@(x) 1/sqrt(sin(x)),0,pi/2)
  # f este constanta, deci derivata ei este 0 => restul = 0, deci precizie
  # maxima. Luam n=1 (derivata de ordin n*2=2)
endfunction
