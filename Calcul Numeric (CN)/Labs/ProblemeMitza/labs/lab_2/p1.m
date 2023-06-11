function p1()
  myone=double(1);

  disp('Epsilonul Masinii');
  disp('Computed');
  my_machine_epsilon(myone)
  disp('Actual');
  eps(class(myone))
  disp('Binary');
  num2float(my_machine_epsilon(myone))
  disp("");

  disp('Epsilonul Masinii Teoretic');
  disp('Computed');
  my_theoretical_machine_epsilon(myone)
  disp('Actual');
  eps(class(myone))/2
  disp('Binary');
  num2float(my_theoretical_machine_epsilon(myone))
  disp("");

  disp('Max Norm');
  disp('Computed');
  my_max_norm(myone)
  disp('Actual');
  realmax(class(myone))
  disp('Binary');
  num2float(my_max_norm(myone))
  disp("");

  disp('Min Norm');
  disp('Computed');
  my_min_norm(myone)
  disp('Actual');
  realmin(class(myone))
  disp('Binary');
  num2float(my_min_norm(myone))
  disp("");

  disp('Max Sub Norm');
  disp('Computed');
  my_max_subnorm(myone)
  #disp('Actual');
  #nu exista functie in octave pentru asta
  disp('Binary');
  num2float(my_max_subnorm(myone))
  disp("");

  disp('Min Sub Norm');
  disp('Computed');
  my_min_subnorm(myone)
  #disp('Actual');
  #nu exista functie in octave pentru asta
  disp('Binary');
  num2float(my_min_subnorm(myone))
endfunction
