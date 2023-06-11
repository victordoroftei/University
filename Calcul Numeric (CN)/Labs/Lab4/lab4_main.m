function l = lab4_main()

  A = [1 1 1; 1 1 2; 2 4 2]
  b = [3 4 8]'

  x_lup = lupsystem(A, b)
  x_cholesky = choleskysystem(A, b)

  A = [1 2 1; 2 5 3; 1 3 3]
  b = [4 10 7]'

  x_cholesky = choleskysystem(A, b)
  x_lup = lupsystem(A, b)

endfunction
