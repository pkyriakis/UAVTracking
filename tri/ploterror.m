    N = max(size(TP));
    Kprev=-1;
    d = [];
    d1 =[];
    uz=[0 0 1]';
    for i=1:max(size(qp))
        rp = qp(i,1:3)';
        if (Kprev == -1)
            for k = 1:N
               nk = faceNormal(TP,k);
               ak = TP.Points(TP.ConnectivityList(k,1),:)';
               % Find intersection with the plane defined by nk
               rpi = rp +nk*(ak-rp)/(nk*uz)*uz; 
               % Find bar. cords of above
               l = cartesianToBarycentric(TP,k,rpi');
               % Check if the point is inside the k-th triangle
               if (0<=l(1) && l(1)<=1 && 0<=l(2) && l(2)<=1 && 0<=l(3) && l(3)<=1)
                   K = k;           
                   break;
               end
            end
        else
           nbs = neighbors(TP,Kprev);
           nbs = nbs(~isnan(nbs));
           for k=1:max(size(nbs))>0
               cn = nbs(k,1);           
               nk = faceNormal(TP,cn);
               ak = TP.Points(TP.ConnectivityList(k,1),:)';
               % Find intersection with the plane defined by nk
               rpi = rp +nk*(ak-rp)/(nk*uz)*uz; 
               % Find bar. cords of above
               l = cartesianToBarycentric(TP,cn,rpi');
               % Check if the point is inside the k-th triangle
               if (0<=l(1) && l(1)<=1 && 0<=l(2) && l(2)<=1 && 0<=l(3) && l(3)<=1)
                   K = cn;           
                   break;
               end      
           end
        end
        d1 = [d1;rpi];
        d = [d norm(rp(3)-rpi(3))];
    end
    plot(d)