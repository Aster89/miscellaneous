function [coeff,A,b] = coefficienti_upgrade(LHS_stencil,RHS_stencil,LHS_degrees,RHS_degrees,colloc)
%COEFFICIENTI_UPGRADE   Coefficienti di uno schema numerico.
%   Questa function determina i coefficienti di uno schema numerico
%   che nei punti definiti da LHS_stencil ha le incognite il cui
%   grado di derivazione è definito da LHS_degrees (i 2 devono essere
%   iso-sized); similmente, al RHS ci sono i termini noti nei punti
%   definiti da RHS_stencil il cui grado di derivazione è contenuto
%   in RHS_degrees. Il punto di collocazione delle schema è colloc.
%
%   NB: colloc 
%   ATTENZIONE!!! Il coefficiente 1 viene assegnato allo zero, che
%   perciò DEVE essere presente in LHS_stencil.
%
%   Ad esempio la chiamata seguente
%
%       coeff = COEFFICIENTI([0 1],[-.5 0 1 2 3],[2 2],[1 0 0 0 0],0)
%
%   fornisce i coefficienti dello schema seguente:
%
%       \   o       o       o       o                  
%       |___|_______|_______|_______|                  
%           |       |                                  
%          1\\      \\               IV ordine
%
%   letti dal basso verso l'alto e da sinistra verso destra

% essendo non definite le potenze negative di 0 (ovvio!) non posso
% sfruttare la sintetica scrittura 0^k in luogo di kroneker_(0,k) e
% dovrei sfruttare la function sign, ma diventa tutto incomprensibile,
% quindi tanto vale shiftare tutte le ascisse nel semiasse positivo
% evitando così il problema alla radice.
xmin = min([LHS_stencil RHS_stencil]); % ascissa minima
xL = LHS_stencil - xmin + 1;           % shift alle x > 0 (strett.)
xR = RHS_stencil - xmin + 1;
xc = colloc - xmin + 1;

dL = LHS_degrees;
dR = RHS_degrees;

ncoeff = length(xL) + length(xR) - 1; % numero di coefficienti
ic = find(xL == xc,1);                % indice punto di collocazione

A = sym('A',[ncoeff ncoeff+1]);

x = [xL xR];
d = [dL dR];

temp = zeros(size(d));
% costruzione del sistema
for k = 0:ncoeff-1
%     A(k+1,:) = [-(xL.^(k - dL)).*prod(k:-1:k-dL+1) (xR.^(k - dR)).*prod(k:-1:k-dR+1)];
    for ii = 1:length(d)
        temp(ii) = prod(k+1:-1:k-d(ii)+1);
    end
    temp(1:length(xL)) = -temp(1:length(xL));
    A(k+1,:) = (x.^(k - d)).*temp;
end

iiL = find(dL<0); % indici relativi ai valori integrali (estremo sinistro valori noti/destro valori incogniti)
iiR = find(dR<0); % indici relativi ai valori integrali (estremo destro valori noti/sinistro valori incogniti)
iiR = iiR + numel(dL);

A(:,iiL) = A(:,iiL) + A(:,iiR); 
A(:,iiR) = [];
A(iiR-1,:) = [];


b = - A(:,ic);
A(:,ic) = [];

coeff = A\b;



