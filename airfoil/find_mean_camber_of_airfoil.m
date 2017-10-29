% clean
clear; close all; clc

% load x and y coordinates
load my-airfoil.mat

% determine mean camber polynomial
n = 7;
mcp = mean_camber(x, y, n, [find(x == min(x)), find(x == max(x))]);

% a lot of points for the camber line
xx = linspace(min(x), max(x)); % x-mesh
yy = polyval(mcp(end:-1:1),xx); % y values

% plot
subplot(2,2,1:2)
plot(x, y, 'o', xx, yy,'.-'), axis equal, axis([-1 27 -1 2]), title('Airfoil')
subplot(2,2,3)
plot(x, y, 'o', xx, yy,'.-'), axis equal, axis([-.2 1 -.2 .6]), title('LE')
subplot(2,2,4)
plot(x, y, 'o', xx, yy,'.-'), axis equal, axis([25.6 26.1 .25 .45]), title('TE')