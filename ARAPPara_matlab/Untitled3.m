function [cl,points] = Untitled3(t,rp,FBpoints)
    
    points=rp;
    for k = 1:max(size(FBpoints))
       for l = 1:max(size(points)) 
           if (sum(abs(points(l,:)-FBpoints(k,:)))<0.0001)
               points(l,:) = [];
               vid = l;
               break;
           end       
       end
       l = 1;
       s = max(size(t));
       while (l <= s) 
           if (isequal(t(l,1),vid) || isequal(t(l,2),vid) || isequal(t(l,3),vid))
                t(l,:)=[];
                s = max(size(t));
           end
           l=l+1;
       end
       for l = 1:max(size(t))
           if (t(l,1) > vid)
               t(l,1) = t(l,1)-1;
           end
           if (t(l,2) > vid)
               t(l,2) = t(l,2)-1;
           end
           if (t(l,3) > vid)
               t(l,3) = t(l,3)-1;
           end
       end
    end
    s=max(size(points));
    k=1;
    while( k <= s)
        if (sum(sum(t==k))==0)
            points(k,:) = [];
            for l = 1:max(size(t))
                if (t(l,1) > k)
                    t(l,1) = t(l,1)-1;
                end
                if (t(l,2) > k)
                    t(l,2) = t(l,2)-1;
                end
                if (t(l,3) > k)
                    t(l,3) = t(l,3)-1;
                end
            end
            k=k-1;
        end
        s = max(size(points));
        k=k+1;
    end
    
    cl=t;    
end
for k=1:max(size(v))
   v(k,:) = (R*v(k,:)')';
end

