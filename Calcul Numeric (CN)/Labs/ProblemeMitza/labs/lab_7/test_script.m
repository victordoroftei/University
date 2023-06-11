x=[0,3,5,8,13];
y=[0,225,383,623,993];
dy=[75,77,80,74,72];
[H,DH]=interpolationHermitCubic(x,y,dy,x);

if all(H==y) && all(DH==dy)
  disp("Correct");
else
  disp("Incorrect");
endif
