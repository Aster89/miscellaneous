function leading_trunc_err = errtrunc(choice) 
%ERRTRUNC Compute truncation error of FD formula
%   This function computes the leading term of the truncation error
%   of a finite difference formula. It accepts the string identifying the schema
%   as input argument.
%   Add other cases in the switch construct.

%% symbolic variables
syms f(x) h

%% taylor expansion of symbolic functions and derivatives
exp_ord = 8;
tf(x) = taylor(f, 'order', exp_ord);
tdf(x) = diff(tf(x));

%% truncation error

switch choice

    case 'IIorder'
        % classic explicit II order I derivative
        norm_coeff = 1;
        trunc_err = tdf(0) - (tf(x) - tf(-x))/(2*x);

    case 'pade'
        % classic Padé
        norm_coeff = 1/sum([1/4 1 1/4]);
        trunc_err = (1/4*tdf(x) + tdf(0) + 1/4*tdf(-x)) - 3/2*(tf(x) - tf(-x))/(2*x);

    case 'IVordIderStag'
        % IV order staggered I derivative
        norm_coeff = 1/sum([1/22 1 1/22]);
        trunc_err = (1/22*tdf(x) + tdf(0) + 1/22*tdf(-x)) - 12/11*(tf(x/2) - tf(-x/2))/x;

    otherwise
        error('Scheme not defined')
        
end

%% normalize truncation error
trunc_err = expand(norm_coeff*trunc_err);

order = 0;
temp = 0;
while temp == 0
    order = order + 1;
    temp = subs(diff(trunc_err,x,order),x,0);
end
leading_trunc_err = subs(diff(trunc_err,x,order),x,0)*x^order/factorial(order);
