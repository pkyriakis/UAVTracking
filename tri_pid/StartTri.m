function [qc, qp] = StartTri(TP, TC, qp0)
    % TP -> triangulation in the physical space
    % TC -> triangulation in the canonical space
    % qp0 -> initial state
    
    N =500;
    q_p_old = qp0;
    qp = zeros(N,5);
    qc = zeros(N,5);
    Dt = 4/N;

    er_sum = [0 0 0]';
    er_dif = [0 0 0]';
    er_prev = [0 0 0]';
    Kprev = -1;

%   reference for sine surface

     ref = linspace(0,18,N);
     ref(2,:) = ref;
     ref(3,:) = 1;  

    
    for k=1:N
        [q_c, J, K, gamma] = PsiInv(q_p_old, TP, TC, Kprev);              
        Kprev = K;
        
        % Calculate errors for the PID
        r_c = [q_c(1); q_c(2); q_c(3)];        
        er = r_c - ref(:,k);        
        er_sum = er_sum + Dt*er;
        er_dif = (er_prev - er)/Dt;
        er_prev = er; 
        
        u_c = LineCon_pid(er, er_sum, er_dif);
        u_p = InputTranfsormation(u_c, q_c, J);
        q_p = PhysicalModel(u_p, q_p_old, Dt);    
        
        q_p_old = q_p;              
        qp(k,:) = q_p';
        qc(k,:) = q_c';
    end
    
end