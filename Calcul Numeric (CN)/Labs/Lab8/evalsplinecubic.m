  function S=evalsplinecubic(nodes,values,type,der_values,x)
   c=splinecubic(nodes,values,type,der_values);
   if x==nodes(end)
     S=values(end);
   else
      poz=find(x<nodes,1)-1;
    %  S=c(poz,1)+c(poz,2)*(x-nodes(poz))+...
    %    c(poz,3)*(x-nodes(poz))^2+c(poz,4)*(x-nodes(4))^3;
    X=x-nodes(poz);
    S=c(poz,1)+X*(c(poz,2)+X*(c(poz,3)+X*c(poz,4)));
   endif
  endfunction