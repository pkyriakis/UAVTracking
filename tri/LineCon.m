function u_c = LineCon(q_c,gamma)


    K1 = [0 0 0; 0 -50 0;0 0 -22];     
    K2 = -[15 0 0; 0 0 0;0 0 0];    

    r_c = [q_c(1); q_c(2); q_c(3)];
    
    null_Ic= null([16 21 0]);
    nlat = null_Ic(:,1)/norm(null_Ic(:,1));
    nlon = null_Ic(:,2)/norm(null_Ic(:,2));

    v = K1*(nlon*nlon'+nlat*nlat')*(r_c-[0 0 1]') + K2*(cross(nlon,nlat));
    
    v=7.5*v/norm(v);

    u_c = [norm(v)/gamma; atan2(v(2),v(1));acos(v(3)/norm(v))];  
end
    