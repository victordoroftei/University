 function [x, ni, rho] = model_sys_lin(A, b, tip = "Jacobi", omega, nr_max_it = 1e+4, err = 1e-14, p = Inf)
  %omega este omis pentru Jacobi si Gauss-Seidel
  M = diag(diag(A));

  if strcmp(tip, "Gauss") == 1

    M = tril(A);

  elseif strcmp(tip, "SOR") == 1

    M = (1 / omega) * diag(diag(A)) + tril(A, -1);

  elseif strcmp(tip, "Jacobi") == 0

    disp("Tip invalid!");
    return;

  end

  N = M - A;
  T = M \ N;
  c = M \ b;

  rho = max(abs(eig(T))); %raza spectrala

  if norm(T, p) >= 1
    disp('Abort!')
    return;
  endif

  factor = norm(T, p) / (1 - norm(T, p));
  x_old = zeros(size(b));
  ni = 1;
  x = x_old;
  while ni < nr_max_it
    x = c + T * x_old;
    if (norm(T, p) / (1 - norm(T, p))) * (norm(x - x_old, p)) <= err
      #x
      #ni
      #rho
      return;
    else
     x_old = x;
     ni += 1;
    endif
  endwhile
  #x
  #ni
  #rho
endfunction
