function c = mean_camber(x, y, n, constrained_indx)
%MEAN_CAMBER Computes the mean camber of an airfoil.
%   Compute the coefficients of a n-degree polynomial corresponding to the
%   mean camber passing through the points of coordinates
%           (x(constrained_indx), y(constrained_indx))
%   of the airfoil whose points have coordinates
%           (x, y).
%
%   The computation makes use of something akin to Gauss' transorms for
%   rectangular linear systems.
%
%   See also constrained_mldivide.

% this check on the input can be improved
if nargin == 2
    n = 3; % default polynomial degree
elseif all(nargin ~= 3:4)
    error('Wrong number of inputs')
end
constrained = nargin > 3;

% size of input array
N = length(x);

% Vandermonde matrix building (only n+1 columns, no need to use vander)
M = zeros(N, n+1);
for ii = 1:n+1
    M(:,ii) = x.^(ii-1);
end

if constrained
    c = constrained_mldivide(M, y, constrained_indx);
else % rely on MATLAB's use of mldivide (Gauss transforms?)
    % c = constrained_mldivide(M, y);
    c = M\y;
end

end
