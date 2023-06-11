function p3()
  type='periodice';
  xmin=-1;xmax=1;xstep=0.1;
  ymin=-1;ymax=1;ystep=0.1;

  clf;axis equal;axis([xmin xmax ymin ymax]);
  xticks(xmin:xstep:xmax);yticks(ymin:ystep:ymax);
  grid on;hold on;

  x=[];
  y=[];

  i=1;
  while 1
    [X,Y]=ginput(1);
    if isempty([X,Y])
      break;
    endif
    plot(X,Y,'*k','MarkerSize',10);
    text(X+0.02,Y+0.02,num2str(i),'fontsize',25);
    i=i+1;
    x=[x,X];y=[y,Y];
  endwhile

  switch type
    case 'periodice'
      x=[x x(1)];y=[y y(1)];
  endswitch

  drawPointsWithSpline(x,y,[xmin,xmax,xstep],[ymin,ymax,ystep],type);
endfunction
