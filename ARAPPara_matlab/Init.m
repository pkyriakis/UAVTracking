% Initial guess for the ARAP algorithm
% Floater's shape preserving method
% x: vertices, t: triangle connectivities

function [X] = Init(rp,t)
    % # of vertices
    vcnt = size(rp,1);
    
    TR = triangulation(t,rp);
    [FBtri,FBpoints] = freeBoundary(TR);
    FBtri = freeBoundary(TR);
    attachedTriangles = vertexAttachments(TR);    
    
    % Boundary vertices count
    vbcnt = size(FBtri,1);
    
    % Find the index of each vertex's neigbhours
    for i = 1: size(rp,1)
        verticesOfTI = TR.ConnectivityList(attachedTriangles{i},:);
        tmp = setdiff(unique(verticesOfTI), i);
        for k = 1:max(size(tmp))
            nb(i,k) = tmp(k);
        end
    end
    
    % Calculate weights
    w = zeros(vcnt,size(nb,2));
    for i=1:vcnt     
        % Current vertix
        v = rp(i,:);
        k=1;
        % Get cords of v's neigbhours
        cnb = find(nb(i,:)~=0);
        vj = TR.Points(nb(i,cnb),:);
        % # of neigbhours
        d = size(vj,1);  
        
        % Caclulate the angles of the "3d polygon"
        % and  ||vj-v||
        angle = zeros(d,1);
        mag = zeros(d,1);
        for k=1:d  
            a1 = vj(k,:);
            if (k == d)
                a2 = vj(1,:);
            else
                a2 = vj(k+1,:);
            end            
            angle(k)=acos(dot(v-a1,v-a2)/(norm(v-a1)*norm(v-a2)));
            mag(k) = norm(vj(k)-v);
        end
        % Find normalazation coeficient rho
        rho = 2*pi/sum(angle);       
        % p is arbitrary
        p = [0 0];
        
        % Put p's first neigbhour in the x-axis
        pj = zeros(d,2);
        pj(1,:) = [mag(1) 0];
        
        % Find all other neigbhours using 
        % succesive rotations and scallings
        for k=1:d-1
            th = rho*angle(k);
            R = [cos(th) -sin(th); sin(th) cos(th)];
            pj(k+1,:) = (R*pj(k,:)')';
            pj(k+1,:) = pj(k+1,:)/norm(pj(k+1,:))*mag(k+1);
        end
        
        % Double loop - for every vertex pk and for every edge 
        % that belongs to the current Ceil
        for k=1:d
            for r=1:d
                if (r == d )
                    s=1;
                else
                    s=r+1;
                end
                r1 = pj(k,:)'; r2 = pj(r,:)'; r3 = pj(s,:)';
                T = [r1-r3 r2-r3];          
                % Check if the three points are colinear - 
                % use some low threshold for zero
                if (det(T)>0.0000001)    
                    l = inv(T)*(p'-r3);
                    l3 = 1-sum(l);
                    % Check if p is inside the thiangle created by the 
                    % above points
                    if (l(1)>0 && l(2)>0 && l3>0 && l(1)<1 && l(2)<1 && l3<1)
                        w(i,k) = w(i,k) + l(1)/d; 
                        w(i,r) = w(i,r) + l(2)/d;
                        w(i,s) = w(i,s) + l3/d;
                        break;
                    end
                end                
            end
        end                      
    end
    
    % Generate a unit square for mapping the boundary
    s = floor(vbcnt/4); r = mod(vbcnt,4);
    square = zeros(4*s+r,2);
    square(1:s,:) = [linspace(1,2,s)' ones(s,1)];
    square(s+1:2*s,:) = [2*ones(s,1) linspace(1.1,2,s)'];
    square(2*s+1:3*s,:) = [linspace(1.9,1,s)' 2*ones(s,1)];
    square(3*s+1:end,:) = [ones(s+r,1) linspace(1.9,1,s+r)'];
       
    % Find the matrix of the linear system
    A = eye(vcnt);
    for k=1:vcnt
        nbs = nb(k,find(nb(k,:)~=0));
        for l=1:size(nbs,2)
            A(k,nbs(l)) = -w(k,l);
        end        
    end
    
    % Delete row and collums that
    % correspond to the boundary
    A(FBtri(:,1),:)=[];
    A(:,FBtri(:,1))=[];

    % Construct right side of the equation
    b = zeros(vcnt,2);    
    for k=1:size(FBtri(:,1),1)
        cv = FBtri(k,1);
        nbcv = nb(cv,[find(nb(cv,:)~=0)]);
        for l=1:size(nbcv,2)
            tmp = nb(nbcv(l),[find(nb(nbcv(l),:)~=0)]);
            b(nbcv(l),:) = b(nbcv(l),:) + w(nbcv(l),find(tmp==cv))*square(k,:);
        end
    end
    % Delete boundary rows - as above
    b(FBtri(:,1),:)=[];    
    
    
    X = zeros(vcnt,2);        
    % Put the unit square on the deleted possitions
    X(FBtri(:,1),:)=square;
    % Put inv(A)b into to the remaining possitions
    X(~X)= inv(A)*b;
    X = X - sqrt(2)*ones(size(X))/2;
    
end
