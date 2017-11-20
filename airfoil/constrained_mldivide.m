function X = constrained_mldivide(A, B, constrained_indx)
%CONSTRAINED_MLDIVIDE Least square solution with constraints.
%   Solves the the overdetermined system(s) A*X = B at th same time
%   (1) exactly, with respect to the equations of index constrained_indx, 
%   (2) in a least square sense, with respect to the other equations.
%
%   In other words, the equations of index constrained_indx are forced
%   to be satisfied exactly, unlike the remaing ones.
%
%   If constrained_indx isn't provided the output falls back on A\B.
%
%   See also mldivide.

%% Explanation of the method
% Consider the case of a single system (X and B are two one-column matrices).
% The system to be solved is A*X = B, where A is an m by n matrix with m > n, or even m >> n (overdetermined system).
% Suppose constrained_indx is 1:c; then the layout of the system is as follows.
% 
%                  A       ×   X  =  B
%              __________            __ 
%             |          |          |  |
%           c |    A1    |    __    |B1|
%             |__________|   |  |   |__|
%             |          |   |  |   |  |
%             |          | × | X| = |  |
%       m - c |    A2    |   |  |   |B2|
%             |          |   |__|   |  |
%             |__________|          |__|
% 
% We want the residual
% 
%         r = A*X - B
% 
% to be as little as possible, provided the residual relative to the first c equations
% 
%         r1 = A1*X - B1
% 
% is exactly zero (here we make the assumption that the first c equations are compatible, i.e. A1 is a full rank matrix).
% 
% 
% We can use the method of Lagrange multipliers, defining the following Lagrange scalar function,
% 
%         phi[X,L] = 1/2*r'*r - L'*(A1*X - B1)
%                  = 1/2*(A*X - B)'*(A*X - B) - L'*(A1*X - B1)
%                  = 1/2*X'*A'*A*X - X'*A'*B + B'*B - L'*(A1*X   - B1 )
%                  = 1/2*X'*A'*A*X - X'*A'*B + B'*B -    (X'*A1' - B1')*L.
% 
% and requiring its partial derivatives with respect to X'
% 
%         diff[phi[X,L], X'] = A'*A*X - A'*B - A1'*L
%         
% and L'
% 
%         diff[phi[X,L], L'] =  - A1*X + B1
% 
% to be zero,
% 
%         A'*A*X = A'*B + A1'*L       (1)
% 
%         A1*X = B1                   (2)
% 
% Upon solving Eq. (1), X is obtained as a function of the Lagrange multiplier L,
% 
%         X[L] = (A'*A)\(A'*B + A1'*L).
% 
% Inserting X[L] in Eq. (2), gives
% 
%         A1*(A'*A)\(A'*B + A1'*L) = B1,
% 
% which can be solved for the Lagrange multiplier L,
% 
%         L = (A1*(A'*A)\A1')\(B1 - A1*(A'*A)\A'*B).
% 
% Inserting L back in Eq. (1), and solving with respect to X, gives the final solution,
% 
%         X = (A'*A)\(A'*B + A1'*(A1*(A'*A)\A1')\(B1 - A1*(A'*A)\A'*B)).
%

constrained = nargin == 3;

if ~constrained % rely on MATLAB's use of Gauss transforms
    X = A\B;
else
    Ac = A(constrained_indx,:);
    Bc = B(constrained_indx,:);
    X = (A'*A)\(A'*B + Ac'*((Ac*((A'*A)\Ac'))\(Bc - Ac*((A'*A)\(A'*B)))));
    %                       \___________________   ___________________/
    %                                            V
    %                                    Lagrange multiplier
end

end
