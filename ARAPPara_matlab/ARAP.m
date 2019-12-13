% ARAP perameterization source code
% Select correct .obj file, which contains texture coordinates
% to be the initial guess of lcal/global algorithm. Input the 
% file name as the first parameter of ARAP function.
% Set the tolerance of convergence. For most common case, 
% tolerance = 0.001 is enough.

function [rp,rc,t]=ARAP(TP)

t = TP.ConnectivityList;
rp = TP.Points;
rc = Init(rp,t);
%rc = TP.Points(:,1:2);

%%%%%%%%%%%%%%%%%%%% Plot Initial Guess %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% trimesh(t,rc(:,1),rc(:,2));
% axis equal;
% title('Initial Guess');

%%%%%%%%%%%%%%%%%%%% Pre-Computations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EV=CalEdgeVectors(rp,t);   %Calculate edge vectors of all the triangles
C=CalCots(rp,t);   %Calculate cot weights of each angle in each triangle 
L=laplacian(rp,t,C);  %Compute cot Laplacian of the mesh
L(1,size(L,1)+1)=1;
L(size(L,1)+1,1)=1;
Linv = inv(L);

%%%%%%%%%%%%%%%%%%%% Local/Global Algorithm %%%%%%%%%%%%%%%%%%%%%%%%%%%%
E=-1;
Epre=0;
iterations=0;
tolerance = 0.001;
while abs(Epre-E)>tolerance     %Iteration stops when the energy converges 
    iterations=iterations+1;    %to the tolerance, which is specified by
    Epre=E;                     %user.
    R=ARAP_Local(rc,t,EV,C);
    rc=ARAP_Global(EV,Linv,t,C,R);
    E=CalRigidEnergy(EV,t,rc,C,R);
    
%%%%%%%%%% Plot iteration results %%%%%%%%%%%%%%%%%%%%%%%%
    %figure
    %trimesh(t,vt(:,1),vt(:,2));
    %axis equal;
    %title1=num2str(iterations);
    %title2=[title1,' Iterations'];
    %title(title2);
    
end

%%%%%%%% Show para result %%%%%%%%%%%%%%%%%%%%%
%  figure
%  trimesh(t,rc(:,1),rc(:,2));
%  axis equal;
%  title1=num2str(iterations);
%  title2=[title1,' Iterations'];
%  title(title2);


%%%%%%%%%% Output the .obj file with texture coordinates to the
%%%%%%%%%% disk, called 'originalname_ARAP.obj'
% newfilename=[fname,'_ARAP.obj'];
% WriteOBJ(newfilename, x, t, vt);