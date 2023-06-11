function ps1()
  f=@(x) (3+sin(10*pi*x)+sin(61*exp(0.8*sin(pi*x)+0.7))).*exp(i*pi*x);
  a=-1;
  b=1;
  m=671;
  type="Cebisev2";
  nrp=10000;

  x=generate_nodes(a,b,m,type);
  y=f(x);
  X=linspace(a,b,nrp);
  z=lagrange_bary(x,y,X,type);
  clf;hold on;grid on;
  plot(real(z),imag(z));
endfunction
