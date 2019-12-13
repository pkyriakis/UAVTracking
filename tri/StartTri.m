function [qc, qp] = StartTri(TP, TC, qp0)
    % TP -> triangulation in the physical space
    % TC -> triangulation in the canonical space
    % qp0 -> initial state
    N = 500;
    qp_old = qp0;
    qp = zeros(N,5);
    qc = zeros(N,5);
    Dt = 4/N;

    Kprev = -1;
    ref = linspace(0,16,200);      

    for k=1:N
        [q_c, J, K, gamma] = PsiInv(qp_old, TP, TC, Kprev);              
        Kprev = K;

        u_c = LineCon(q_c,gamma);
        u_p = InputTranfsormation(u_c, q_c, J);
        q_p = PhysicalModel(u_p, qp_old, Dt);        
        qp_old = q_p;
        q_c_old = q_c;
               
        qp(k,:) = q_p';
        qc(k,:) = q_c';
    end
    
end