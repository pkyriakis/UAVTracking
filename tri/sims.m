load('tri_sine.mat');
[qc, qp] = StartTri(TP, TC, qp0);
trimesh(TP.ConnectivityList, TP.Points(:,1),TP.Points(:,2),TP.Points(:,3))
hold on
plot3(qp(:,1),qp(:,2),qp(:,3))
l = legend('Reference surface', 'Actual path');
set(l,'FontSize',20)
set(l,'Location','Best')
xlabel('x');zlabel('y');zlabel('z');
axis([-1 20 -1 20 -3 3])

figure;
trimesh(TP.ConnectivityList, TC.Points(:,1),TC.Points(:,2),ones(676,1))
hold on
plot3(smooth(qc(:,1)),smooth(qc(:,2)),smooth(smooth(qc(:,3))))
hold on
plot3(2.7+1.6*cos(s),3+1.6*sin(s),ones(1,500))
xlabel('x');zlabel('y');zlabel('z');


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