function f1()
  n=10;

  proots=1:n;
  roots_orders=2*ones(1,n);

  p=poly([proots proots]);
  nc=condpolmroot(p,proots,roots_orders);
  [proots' roots_orders' nc']

  test_pol_disturbance(p);
endfunction
