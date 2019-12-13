function u_p = InputTranfsormation(u_c,q_c,J)
    
    % Initialization
    C = zeros(2,3);
    D = eye(2);
    M = eye(3);
    Jd = zeros(3,3);
    
    % Construct needed elements of Cartesian tensor
    e12=[1 0 0]'*[0 1 0];
    e21=[0 1 0]'*[1 0 0];
    e33=[0 0 1]'*[0 0 1];
    
    % Get canonical angles
    th_c = q_c(5);
    phi_c = q_c(4);    
    
    % Construct the vector cc and its derivatives
    cc = [sin(th_c)*cos(phi_c);sin(th_c)*sin(phi_c);cos(th_c)];
    cc_phi_c = [-sin(th_c)*sin(phi_c);sin(th_c)*cos(phi_c);0];
    cc_th_c = [cos(th_c)*cos(phi_c);cos(th_c)*sin(phi_c);-sin(th_c)];
    
    % Find the length ratio
    gamma = sqrt(cc'*(J')*J*cc);

    % Find the coefficients appearing in C,D
    Aphi = (cc')*(J')*(e12-e21)/(gamma^2-(cc')*(J')*e33*J*cc);
    Ath = -gamma*[0 0 1]/sqrt(gamma^2-(cc')*(J')*e33*J*cc);

    % Find C
    C(1,1) = Aphi*Jd*cc;
    C(2,1) = Ath*(2*(gamma^2)*Jd-(cc')*((Jd')*J+(J')*Jd)*cc*J)*cc/(2*gamma^3);
 
    % Find D
    D(1,1) = Aphi*J*cc_phi_c;
    D(1,2) = Aphi*J*cc_th_c;
    D(2,1) = Ath*J*(cc_phi_c*(cc')-cc*(cc_phi_c'))*(J')*J*cc/gamma^3;
    D(2,2) = Ath*J*(cc_th_c*(cc')-cc*(cc_th_c'))*(J')*J*cc/gamma^3;
    
    % Find M
    M(1,1) = gamma;
    M(2:3,1) = C*cc;
    M(2:3,2:3) = D;

    % Transform the control
    u_p = M*u_c;
    
    if ([0 0 1]*cc>0.999999999)
        u_p = u_c;
    end
 end
