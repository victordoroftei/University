function drawPointsWithSpline(x,y,xinfo,yinfo,type='deBoor')
  #type should only be 'deBoor', 'naturale' or 'periodice'
  x1=xinfo(1);x2=xinfo(2);xstep=xinfo(3);
  y1=yinfo(1);y2=yinfo(2);ystep=yinfo(3);

  clf;grid on;hold on;
  axis equal;axis([x1 x2 y1 y2]);
  xticks(x1:xstep:x2);yticks(y1:ystep:y2);

  plot(x,y,'*k','MarkerSize',10);

  nodes=linspace(0,1,length(x));
  time=linspace(0,1,1000);
  sx=getSplineCubicEval(nodes,x,type,[],time);
  sy=getSplineCubicEval(nodes,y,type,[],time);
  plot(sx,sy,'-r','LineWidth',2);
endfunction
