function p3_draw(f,x,a,b)
  clf; hold on; grid on; xlim([a b]); xticks(a:b);axis square;
  X=linspace(a,b,501);
  m=length(x);

  Y=lagrange_basis_num(x,X);
  for k=1:m
    plot(X,Y(k,:),'linewidth',1);
  endfor

  plot(X,f(X),'linewidth',2);

  plot(X,lagrange_poly_num(x,f(x),X),'linewidth',3);
  delete (findobj ("tag", "legend"));
endfunction
