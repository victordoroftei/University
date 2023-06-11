function rest=gauss_rest_sym(w,a,b,mobile_nodes,a_flag=0,b_flag=0,x,theta)
  # calculeaza restul Gauss (+ Gauss-Radau si Gauss-Lobatto)
  # w e ponderea, a si b sunt capetele de integrare
  # mobile_nodes sunt nodurile ce nu au fost fixate la aflarea polinomului
  # a_flag=1 inseamna ca a a fost fixat la alegerea nodurilor
  # b_flag=1 inseamna ca b a fost fixat la alegerea nodurilor
  # (a_flag,b_flag)=(0,0) -> Gauss; (1,0) sau (0,1) -> Radau; (1,1) -> Lobatto
  # x este simbolul lui w
  # theta este simbolul lui f derivat de un nr. de ori intr-un xi
  if nargin<7
    syms x
  endif
  if nargin<8
    syms theta
  endif
  f_to_integrate=prod(x-mobile_nodes)^2*w;
  if a_flag
    f_to_integrate*=(x-a);
  endif
  if b_flag
    f_to_integrate*=(b-x);
  endif
  n=length(mobile_nodes)+a_flag+b_flag;
  n_term=sym(2)*n-a_flag-b_flag;
  integral_val=int(f_to_integrate,x,a,b);
  rest=integral_val*theta/factorial(n_term);
endfunction
