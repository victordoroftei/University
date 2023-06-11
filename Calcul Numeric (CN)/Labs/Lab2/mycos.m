function y=mycos(x)

  x = reducereper(x);

  semn = 1;

  if x > 3 * pi / 2 # Cadranul IV
      x = 2 * pi - x;

  elseif x > pi # Cadranul III
      x = x - pi;
      semn = -1;

  elseif x > pi / 2 # Cadranul II
      x = x - (pi / 2);
      semn = -1;

  end

  if x <= pi / 4
      y = cosred(x);

  else
      y = mysin((pi / 2) - x);
  end

  y = semn * y;

endfunction
