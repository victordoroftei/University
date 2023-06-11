function p4()
  ani=1900:10:2010;
  pops=ani;
  pops(1:6)=[75995,91972,105710,123200,131670,150700];
  pops(7:12)=[179320,203210,226510,249630,281420,308790];

  disp("Method 1");
  [coefs1,err1]=mcmmpSimplePoly(ani,pops,3);
  coefs1=coefs1';
  f1=@(t) polyval(coefs1,t);

  coefs1
  err1
  [1975, f1(1975)]
  [2010, f1(2010)]

  disp("Method 2");
  #y=K*e^(lambda*t) <=> log(y)=lambda*t+log(K)*1
  [coefs2,err2]=mcmmpSimplePoly(ani,log(pops),1);
  coefs2(2)=exp(coefs2(2));
  f2=@(t) coefs2(2)*exp(coefs2(1)*t);

  coefs2
  err2
  [1975, f2(1975)]
  [2010, f2(2010)]

  if err1<err2
    disp("First method is better");
  elseif err2<err1
    disp("Second method is better");
  else
    disp("Both methods have the same error");
  endif
endfunction
