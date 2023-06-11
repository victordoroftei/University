function p2_draw(x,a,b)
  clf; hold on; grid on; xlim([a b]); xticks(a:b);axis square;
  X=linspace(a,b,501);
  Y=lagrange_basis_num(x,X);
  m=length(x);
  for k=1:m
    plot(X,Y(k,:),'linewidth',1);
  endfor
  delete (findobj ("tag", "legend"));
endfunction
