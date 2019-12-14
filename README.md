# UAVTracking

Matlab code and simulink models for the UAV path and surface tracking method presented in the following papers:

[(1) P. Kyriakis and G. Moustris, "Terrain Following for Fixed-Wing Unmanned Aerial Vehicles Using Feedback Equivalence," in IEEE Control Systems Letters, vol. 3, no. 1, pp. 150-155, Jan. 2019.](https://ieeexplore.ieee.org/abstract/document/8408539)

[(2) G. P. Moustris, P. Kyriakis and C. S. Tzafestas, "Feedback Equivalence Between Curve & Straight Line Tracking for Unmanned Aerial Vehicles," 2018 European Control Conference (ECC), Limassol, 2018, pp. 2904-2908.](https://ieeexplore.ieee.org/abstract/document/8550579)

The code uses the ARAP (As-Rigid-As-Possiple) mesh paramtrization method presented [here](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1467-8659.2008.01290.x) 

# Requirements 
Matlab and Simulink 2017 or above. 
[Computational Geometry toolbox](https://www.mathworks.com/help/matlab/computational-geometry.html?s_tid=CRUX_lftnav)

# Run
The **simulink** folder cotains 3 models that impement the continuous 3d path tracking (simulation_3d_line_new.slx), the polygonal path tracking (simulation_poly_new.slx), and the continuous surface tracking (simulation_sufc_new.slx). 

The **tri** folder contains the triangulated surface tracking algorithm using the vector field controller described in (1). Run the **sims.m** script to start. The parameters of the controller can be adjusted in the **LineCon.m** file.

The **tri_pid** folder is same as above but uses a PID controller. 

