function pp4_draw(f,a,b,type={'echidistante','Cebisev2'},col={'r','g'},m=11)
  clf; hold on; grid on; xlim([a b]); xticks(a:b);axis square;
  x=linspace(a,b,501);
  plot(x,f(x),'b','linewidth',2);
  l={'f'};
  for i=1:length(type)
   nodes=generate_nodes(a,b,m,type{i});
   values=f(nodes);
   plot(nodes,values,'ok','markerfacecolor',col{i},'markersize',8);
   plot(x,lagrange_bary(nodes,values,x),col{i},'linewidth',2);
   l{end+1}=type{i};
   l{end+1}=['L cu ' type{i}];
  endfor
  legend(l,"location", "northeastoutside");
  set(gca,"fontsize", 17);
endfunction
