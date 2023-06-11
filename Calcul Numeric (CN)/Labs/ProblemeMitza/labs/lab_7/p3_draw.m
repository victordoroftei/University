function p3_draw(x,y,dy,a,b)
  clf; hold on; grid on; xlim([a b]); xticks(a:b);axis square;
  X=linspace(a,b,501);
  plot(X,interpolationHermit(x,y,dy,X),'linewidth',2);
  for k=1:length(x)
    plot(X,dy(k).*(X-x(k))+y(k),'linewidth',2);
  endfor
  plot(x,y,'.r','MarkerSize',12);
  set(gca,"fontsize", 17)
endfunction
