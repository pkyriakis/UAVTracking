% curve plot - physical
s=ezplot3('10*exp(0.1*t)','sin(t)','cos(t)',[0,3*pi]);
set(s,'linestyle','--');
set(s,'linewidth',1.5);
hold on; 
plot3(qp.Data(:,1),qp.Data(:,2),qp.Data(:,3))
l = legend('Reference path', 'Actual path');
set(l,'FontSize',20)
set(l,'Location','Best')

% curve plot - canonical
s=plot3(linspace(0,max(qc.Data(:,1)),max(size(qc.Data))),zeros(1,max(size(qc.Data))),zeros(1,max(size(qc.Data))));
set(s,'linestyle','--');
set(s,'linewidth',1.5);
axis([-1 11 -1 1 -0.7 0.7])
hold on
grid on
s = plot3(qc.Data(:,1),qc.Data(:,2),qc.Data(:,3));
l = legend('Reference path','Actual path');
set(l,'FontSize',20)
set(l,'Location','Best')
xlabel('x');ylabel('y');zlabel('z');

% surface plot - physical
ezmesh('t','10*exp(0.1*s)','cos(s)*cos(t)',[0,2*pi,0,2*pi])
hold on
grid on
plot3(qp(:,2),qp(:,3),qp(:,4))
l = legend('Reference surface', 'Actual path');
set(l,'FontSize',20)
set(l,'Location','Best')

% surface plot - canonical
m=ezplot3('x','x','1',[0,6.3]);
set(m,'linestyle','--');
set(m,'linewidth',1.5);
hold on
grid on
plot3(qc(:,2),qc(:,3),qc(:,4));
l = legend('Reference path' ,'Actual path');
set(l,'FontSize',20)
set(l,'Location','Best')
axis([-1 7 -1 7 -1 2])

% polygonal chain plot - physical 
plot3(w.Data(1,:,1),w.Data(2,:,1),w.Data(3,:,1),'--')
hold on
plot3(qp.Data(:,1),qp.Data(:,2),qp.Data(:,3))
grid on
l = legend('Reference path' ,'Actual path');
set(l,'FontSize',20)
set(l,'Location','Best')
xlabel('x');ylabel('y');zlabel('z');

% polygonal chain plot - canonical 
s=plot3(linspace(0,1,73),zeros(1,73),zeros(1,73));
set(s,'linestyle','--');
set(s,'linewidth',1.5);
axis([-0.3 1 -0.3 0.3 -0.3 0.3])
hold on
grid on
plot3(qc.Data(:,1),qc.Data(:,2),qc.Data(:,3))
l = legend('Reference path' ,'Actual path');
set(l,'FontSize',20)
set(l,'Location','Best')
xlabel('x');ylabel('y');zlabel('z');

