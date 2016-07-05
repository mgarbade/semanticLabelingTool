function [ inside ] = inpoly(polygon,xt,yt)

rows = size(polygon);
npoints = rows(1);
% disp (['numPoints = ' num2str(npoints)]);
inside = 0;

xold = polygon(npoints,1);
yold = polygon(npoints,2);

for i = 1:1:npoints

   xnew = polygon(i,1);
   ynew = polygon(i,2);

      if (xnew > xold) 
         x1=xold;
         x2=xnew;
         y1=yold;
         y2=ynew;
      else 
         x1=xnew;
         x2=xold;
         y1=ynew;
         y2=yold;
      end

      if ((xnew < xt) == (xt <= xold) & (yt-y1)*(x2-x1) < (y2-y1)*(xt-x1) ) 
               inside=~inside;
      end

      xold=xnew;
      yold=ynew;

end

