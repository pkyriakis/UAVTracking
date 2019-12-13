function q_p = PhysicalModel(u_p, q_p_old, Dt)    
    q_p = zeros(5,1);
    q_p(1,1) = q_p_old(1,1) + Dt*u_p(1)*sin(u_p(3))*cos(u_p(2));
    q_p(2,1) = q_p_old(2,1) + Dt*u_p(1)*sin(u_p(3))*sin(u_p(2));
    q_p(3,1) = q_p_old(3,1) + Dt*u_p(1)*cos(u_p(3));
    q_p(4,1) = q_p_old(4,1) + Dt*u_p(2);
    q_p(5,1) = q_p_old(5,1) + Dt*u_p(3);
end