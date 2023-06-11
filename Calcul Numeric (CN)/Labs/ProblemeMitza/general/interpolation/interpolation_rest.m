function rest=interpolation_rest(x,X,theta)
  #x -> punctele folosite pentru delimitare
  #X -> punctele/simbolul in care se doreste formula restului
  #theta -> valorile derivatei de ordin m sau simbolul aferent
  um=prod(X-x');
  rest=um.*theta/factorial(length(x));
endfunction
