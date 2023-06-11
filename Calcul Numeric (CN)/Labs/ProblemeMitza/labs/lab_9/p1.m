function p1()
  clf;hold on;
  putere=5;

  x=10^(1/putere)*rand(1,100);
  f=1+2*(x.^putere+2*rand(1,100));
  plot(x,f,'or','markerfacecolor','r','markersize',2);
  [coefs,eroare]=mcmmpSimplePoly(x,f,putere)
  p=@(X) polyval(coefs,X);
  fplot(p,[0,10^(1/putere)],'-b','linewidth',3);
  polyfit(x,f,putere)
endfunction
