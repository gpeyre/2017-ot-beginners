%%
% Test for 1-D optimal transport.

N = 40; 
vmax = 20; 
SetAR = @(ar)set(gca, 'PlotBoxAspectRatio', [1 ar 1]);

% generate Gaussian mixtures points in 1-D

x = 14 + 2*randn(N,1);
x = round(clamp(x,0,vmax));
y = 6 + 3*randn(N,1);
y = round(clamp(y,0,vmax));


ms = 30;
r = .2; E = 0*x + randn(N,1)*r;
% scatter plot
clf;
subplot(2,1,1);
plot(x, E, '.r', 'MarkerSize', ms); axis([0 vmax -.5 .5]); axis equal;
set(gca, 'YTick', []);
subplot(2,1,2);
plot(y, E, '.b', 'MarkerSize', ms); axis([0 vmax -.5 .5]); axis equal;
set(gca, 'YTick', []);


% histogram
subplot(2,1,1);
hx = hist(x,1:vmax); 
bar(1:vmax,hx, 'r'); axis tight;
subplot(2,1,2);
hy = hist(y,1:vmax); 
bar(1:vmax,hy, 'b'); axis tight;

%%
% animation on histograms

% sort
xs = sort(x);
ys = sort(y);
%
figure(2);
while true
for i=[1:K, K-1:-1:1]
    t = (i-1)/(K-1);
    z = (1-t)*xs+t*ys;
    hz = hist(z,1:vmax); 
    clf;
    subplot(3,1,1);
    plot(z, E, '.', 'color', [1-t,0,t], 'MarkerSize', ms); axis([0 vmax -.5 .5]); axis equal;
    title('Optimal transport');
    subplot(3,1,2);
    bar(1:vmax,hz, 'FaceColor', [1-t,0,t]); axis([0,vmax,0,8]);
    title('Optimal transport histogram interpolation');
    subplot(3,1,3);
    bar(1:vmax,(1-t)*hx+t*hy, 'FaceColor', [1-t,0,t]); axis([0,vmax,0,8]);
    title('Linear histogram interpolation');
    drawnow;
end
end

