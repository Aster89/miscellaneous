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
