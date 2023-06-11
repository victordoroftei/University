function p2_draw(f,df,a,b,type={'echidistante','Cebisev2'},col={'r','g'},m=11)
  clf; hold on; grid on; xlim([a b]); xticks(a:b);axis square;
  x=linspace(a,b,501);
  plot(x,f(x),'b','linewidth',2);
  l={'f'};
  for i=1:length(type)
   nodes=generate_nodes(a,b,m,type{i});
   plot(x,interpolationHermit(nodes,f(nodes),df(nodes),x),col{i},'linewidth',2);
   l{end+1}=type{i};
  endfor
  legend(l,"location", "northeastoutside");
  set(gca,"fontsize", 17);
endfunction
