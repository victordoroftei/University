function w = coefs_bary(x, type = "none")

  m = length(x) - 1;

  switch type
    case "none"

      for j = 0:m

        w(j + 1) = 1 / prod(x(j + 1) - x([1:j, j + 2:end]));  # j + 1 pt. ca in Octave se incepe de la 1 indexarea, nu de la 0

      endfor

    case "echidistante"

      for j = 0:m

        w(j + 1) = (-1) ^ j * nchoosek(m, j);

      endfor


    case "cebisev1"

      j = 0:m;
      w = (-1) .^ j .* sin((2 * j + 1) * pi) / (2 * m + 2);  # .^ si .* -> . se pune cand facem operatiuni pe vector, cu componentele

    case "cebisev2"


      j = 0:m;
      w = (-1) .^ j;
      w(1) = w(1) / 2;
      w(end) = w(end) / 2;

  endswitch

endfunction
