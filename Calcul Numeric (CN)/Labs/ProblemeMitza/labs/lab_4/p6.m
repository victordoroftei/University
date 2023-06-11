function p6()
  #exista memoizare in Octave, deci pentru datele cele mai corecte,
  #ar trebui sa se comenteze pe rand solveLUP si solveLUP2
  n=300;
  A=randi(20,n,n);
  b=A*ones(n,1);

  t1=time();
  solveLUP2(A,b);
  t2=time();
  solveLUP(A,b);
  t3=time();

  disp("Physical");
  t2-t1
  disp("Logical");
  t3-t2
endfunction
