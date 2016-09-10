function x2 = curvflow( n, m, x1, t1, t2)
% CURVFLOW - Evolution of Fluid Interface under Curvature Flow 
%
% x = curvflow( n, m, t) returns coordinates of fluid interface
% Inputs: n = number of time step
%         m = number of spatial discretization points
%         x1 = coordinates of fluid interface at time t1
%         t1 = time evoluation starts
%         t2 = time evoluation ends
% Outputs: x2 = coordinates of fluid interface at time t2
% Use Fourier method for spatial discretization, and explicit Euler for
% time-stepping.
% Hai 09/09/2016

dt = (t2-t1)/n; % time step

xtemp = x1;
for tstep = 1:n
    f = 1/m*ftransform(m)*xtemp; % function value in fourier space
    fp = 1i*(repmat((-m/2:m/2-1)',1,size(f,2))).*f;
    fpp = -(repmat((-m/2:m/2-1)'.^2,1,size(f,2))).*f;
    xp = ftransform(m)\(m*fp);
    xpp = ftransform(m)\(m*fpp); 
    xpt = repmat(((xp(:,2).*xpp(:,1)-xp(:,1).*xpp(:,2))./(xp*xp').^2),1,2)...
        *[xp(:,2),-xp(:,1)];
    xtemp = xtemp + xpt*dt;
end
x2 = xtemp;