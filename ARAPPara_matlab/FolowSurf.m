function [X] = FolowSurf(fname)
    [rp,rc,t]=ARAP(fname);
    TRc = triangulation(t,rc);
    TRp = triangulation(t,rp);
    
    [FBtri,FBpoints] = freeBoundary(TRc);
    mid = floor(size(FBpoints,1)/2);    
    cline = [linspace(FBpoints(1,1),FBpoints(mid+1,1),500); linspace(FBpoints(1,2),FBpoints(mid+1,2),500)]';
    tri = pointLocation(TRc,cline);
    pline = zeros(size(cline,1),3);
    
    for k=1:max(size(tri))
        bar = cartesianToBarycentric(TRc,tri(k),cline(k,:));
        pline(k,:) = barycentricToCartesian(TRp,tri(k),bar);
    end
    
    plot(cline(:,1),cline(:,2),'black')
    hold on
    trimesh(t,rc(:,1),rc(:,2))
    
    figure;
    plot3(pline(:,1),pline(:,2),pline(:,3),'black')
    hold on
    trimesh(t,rp(:,1),rp(:,2),rp(:,3))

end