function p6()
  n=10;
  nr_iterations=100;
  omega=1.15;
  norm_order=2;

  A=diag(5*ones(n,1),0)+diag((-1)*ones(n-1,1),1)+diag((-1)*ones(n-1,1),-1);
  A=A+diag((-1)*ones(n-3,1),3)+diag((-1)*ones(n-3,1),-3);
  b=[3;2;2;ones(n-6,1);2;2;3];
  solutions=ones(n,1);

  y1=[];
  y2=[];
  y3=[];
  for nr_it=1:nr_iterations
    y1=[y1 norm(solveJacobi(A,b,nr_it)-solutions,norm_order)];
    y2=[y2 norm(solveGaussSeidel(A,b,nr_it)-solutions,norm_order)];
    y3=[y3 norm(solveSOR(A,b,omega,nr_it)-solutions,norm_order)];
  endfor
  y1=nonzeros(y1);
  y2=nonzeros(y2);
  y3=nonzeros(y3);
  clf; hold on;
  semilogy(y1);
  semilogy(y2);
  semilogy(y3);
  L={'Jacobi','GaussSeidel','SOR'};
  legend(L,'location','northeastoutside');
endfunction
