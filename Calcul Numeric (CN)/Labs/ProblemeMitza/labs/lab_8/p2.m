function p2()
  f=@(x) x.^3+1;
  x=[0 2 3 5 10];
  y=f(x);
  xv=[10 2 5 3 0]
  types={'complete','naturale','derivate2','deBoor'};
  derValues={[0,300],[],[0,60],[]};
  for i=1:length(types)
    disp(types{i});
    if all(getSplineCubicEval(x,y,types{i},derValues{i},xv)==f(xv))
      disp("Correct");
    else
      disp("Incorrect");
    endif
  endfor
endfunction
