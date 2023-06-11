function pp5()
  x=[0,pi/6,pi/4,pi/3,pi/2];
  type='none';
  sinx=[0,1/2,sqrt(2)/2,sqrt(3)/2,1];
  cosx=[1,sqrt(3)/2,sqrt(2)/2,1/2,0];
  degrees=5;

  radians=5*pi/180;

  disp("Calculated sin");
  lagrange_bary(x,sinx,radians,type)
  disp("Actual sin");
  sin(radians)
  disp("Calculated cos");
  lagrange_bary(x,cosx,radians,type)
  disp("Actual cos");
  cos(radians)
endfunction
