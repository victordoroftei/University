function p1()
  a=-10;
  b=10;
  m=30;
  nr_points=5;
  type='Cebisev1';

  x=generate_nodes(a,b,m,type);
  y=randi(100,1,m);
  #X=a+rand(1,nr_points)*(b-a);
  X=[1.5, 4, -3.3];

  #lagrange_bary(x,y,X)
  lagrange_poly_num(x,y,X)
endfunction
