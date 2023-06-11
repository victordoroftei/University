function t=testlab1()

  # Test-lab1: Pentru f=sin(x), afisati (simbolic)
  # aproximantul Pade R de ordin (1,2) si polinomul Taylor T de ordin 1+2.
  # Apoi, reprezentati grafic, in aceeasi figura, cu legenda,
  # graficele pentru f, R si T, pe intervalul [-3,4].

  x = sym('x');
  f = sin(x);

  r12 = pade_sym(f, 1, 2, x);
  disp("R(1, 2):\n");
  disp(r12);

  t3= taylor(f, x, 0, "order", 1 + 2 + 1);
  disp("\nT_3 pt. f(x):\n");
  disp(t3);

  clf;
  hold on;
  grid on;

  fh = function_handle(f);
  r12h = function_handle(r12);
  t3h = function_handle(t3);

  interval = [-3, 4];
  fplot(fh, interval);
  fplot(r12h, interval);
  fplot(t3h, interval);

  L = {"f(x) = sin(x)"}
  L{end + 1} = "R(1, 2)";
  L{end + 1} = "T_3 f(x)";

  legend(L, "location", "northeastoutside");

endfunction
