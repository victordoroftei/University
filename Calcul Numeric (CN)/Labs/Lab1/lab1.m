function L=lab1()

  x = sym('x');
  f = e^x;

  r11 = pade_sym(f, 1, 1, x);
  r12 = pade_sym(f, 1, 2, x);
  disp("R_1,1: ");
  disp(r11);

  disp("\n\nR_1,2: ");
  disp(r12);

  figure(1);
  clf;
  hold on;
  grid on;

  fh = function_handle(f);
  fplot(fh, [-1, 1]);
  L = {'f(x) = e ^ x'}

  r11h = function_handle(r11);
  fplot(r11h, [-1, 1]);
  L{end + 1} = 'R1,1'

  r12h = function_handle(r12);
  fplot(r12h, [-1, 1]);
  L{end + 1} = 'R1,2';

  maclaurin = taylor(f, x, 0, 'order', 11);
  maclaurinh = function_handle(maclaurin);
  disp("\n\nMaclaurin: ");
  disp(maclaurin);
  fplot(maclaurinh, [-1, 1]);
  L{end + 1} = "Maclaurin";

  legend(L, 'location', 'northeastoutside');

  figure(2);
  clf;
  hold on;
  grid on;

  g = log(1 + x);
  gh = function_handle(g);
  fplot(gh, [-1, 1]);
  L = {'g(x) = ln(1 + x)'}

  r22 = pade_sym(g, 2, 2, x);
  disp("\n\nR_2,2: ");
  disp(r22);

  r22h = function_handle(r22);
  fplot(r22h, [-1, 1]);
  L{end + 1} = 'R2,2';

  r31 = pade_sym(g, 3, 1, x);
  disp("\n\nR_3,1: ");
  disp(r31);

  r31h = function_handle(r31);
  fplot(r31h, [-1, 1]);
  L{end + 1} = 'R3,1';

  maclaurin = taylor(g, x, 0, 'order', 11);
  maclaurinh = function_handle(maclaurin);
  fplot(maclaurinh, [-1, 1]);
  disp("\n\nMaclaurin: ");
  disp(maclaurin);
  L{end + 1} = "Maclaurin";

  legend(L, 'location', 'northeastoutside');

endfunction
