function [q_c, J, K, gamma]   = PsiInv(q_p, TP, TC, Kprev)
      
    rp = q_p(1:3,1);
    uz = [0 0 1]';
    N = max(size(TP));
    
    K = 0; % Active triangle
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
    % If K = 0 then the intersection lies outside of the 
    % triangulated surface
    if (K == 0)
        % Closest vertex to rp
        v1 = nearestNeighbor(TP,rp');
        % Find the two boundary edges that have v1 in common
        B = freeBoundary(TP);
        Bv = [];
        for i=1:max(size(B))
           if (B(i,1) == v1 || B(i,2) == v1)
               Bv(end+1,:) = B(i,:);
           end
        end

        if (max(size(Bv))>0)
            % Find the triangles defined by the above edges
            % and pick a vertix for each of them
            t1 = cell2mat(edgeAttachments(TP,Bv(1,1),Bv(1,2)));
            t2 = cell2mat(edgeAttachments(TP,Bv(2,1),Bv(2,2)));
            ak1 = TP.Points(TP.ConnectivityList(t1,1),:)';
            ak2 = TP.Points(TP.ConnectivityList(t2,1),:)';
        
            % Find their normals
            n1 = faceNormal(TP,t1);        
            n2 = faceNormal(TP,t2);
        
            % Find their intersection
            rpi1 = rp +n1*(ak1-rp)/(nk*uz)*uz; 
            rpi2 = rp +n2*(ak2-rp)/(nk*uz)*uz; 
        
            % Pick the active triangle
            if (norm(rpi1-rp) <= norm(rpi2-rp))
                K = t1;
            else
                K = t2;
            end     
        else
           tmp = cell2mat(vertexAttachments(TP,v1));
           K = tmp(1,end);
        end
        
    end         
    % Find matrixes Tp and Tc
    tvp = TP.ConnectivityList(K,:);
    akp = TP.Points(tvp(1),:)';
    bkp = TP.Points(tvp(2),:)';
    ckp = TP.Points(tvp(3),:)';
    Tp = [akp-ckp bkp-ckp];
    
    tvc = TC.ConnectivityList(K,:);
    akc = TC.Points(tvc(1),:)';
    bkc = TC.Points(tvc(2),:)';
    ckc = TC.Points(tvc(3),:)';
    Tc = [akc-ckc bkc-ckc];

    % Calculate Jacobian    
    J = zeros(3,3);    
    J(:,1:2) = Tp*inv(Tc);
    J(:,3) = uz;    
    
    % Find the point in the canonical space
    r_c = inv(J)*(rp-ckp+Tp*inv(Tc)*ckc);
    
    % Get physical angles and their unit vector
    th_p = q_p(5);
    phi_p = q_p(4);
    cp = [sin(th_p)*cos(phi_p);sin(th_p)*sin(phi_p);cos(th_p)];
    
    % Find canonical phi, th   
    cc = inv(J)*cp/norm(inv(J)*cp);    
    phi_c = atan2(cc(2),cc(1));
    th_c = acos(cc(3));   
    % Canonical space-state vector
    gamma = sqrt(cc'*(J')*J*cc);
    q_c =[r_c;phi_c;th_c];   
end












