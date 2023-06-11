function y = mysin(x,digits=1000)

  x = reducereper(x, digits);
  semn = 1;

  if x > 3 * pi / 2 # Cadranul IV
      x = 2 * pi - x;
      semn = -1;
      # disp(x);

  elseif x > pi # Cadranul III
      x = x - pi;
      semn = -1;
      # disp(x);

  elseif x > pi / 2 # Cadranul II
      x = x - pi / 2;
      # disp(x);
  end

  if x <= pi / 4
      y = sinred(x);

  else
      y = mycos((pi / 2) - x);

  end

  y = semn * y;

endfunction
