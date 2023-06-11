function p1()
  f=@(x) x.^3+1;
  x=[0 2 3 5 10];
  y=f(x);
  types={'complete','naturale','derivate2','deBoor'};
  derValues={[0,300],[],[0,60],[]};
  for i=1:length(types)
    disp(types{i});
    getSplineCubicCoefs(x,y,types{i},derValues{i})
  endfor
endfunction
