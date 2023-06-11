function p=pb9()

  x = sym('x');
  theta = sym('theta');
  inner_f = 2 * x * sin(theta);
  disp(inner_f)
  f = cos(inner_f)

  j_0 = integral(function_handle(f, theta), 0, pi)
  disp(j_0);

endfunction
