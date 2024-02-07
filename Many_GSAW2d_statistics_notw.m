function [walk_lenght,Rg,trapped] = Many_GSAW2d_statistics_notw (varargin)
%%
% Crea diversi random walk facendo importance sampling:
% pesi = vicini_liberi/vicini_totali
% Ogni step è pesato separatamente, ma mano che si va avanti i random walk
% finiti in una trappola ("cul-de-sac") vegono scartati dal calcolo dello step successivo
% per sampling limitati si notano bias nelle configurazioni ottenute
% Riceve in input
% 1) lunghezza random walk
% 2) numero random walk generati
% 3) Temperatura interazioni vicino-vicino (0 se non si indica nulla)
% Da in output:
% - walk_lenght -> lunghezza massima raggunta dai walk nella simulazione
% - Weight -> Peso totale per ogni passo
% - Ree(_w) -> che è la distanza testa coda al quadrato (_w=pesata)
% - Rg(_w) ->che è la deviazione standard (_w=pesata) dalla media dello posizioni dei diversi
%   monomeri del polimero 
% - trapped -> numero di walk rimasti intrappolati
%%
% DICHIARAZIONE VARIABILI
if nargin<3
    T=0; 
else 
  T=varargin{3};
end
walk_lenght = varargin{1};
walk_number = varargin{2};
trapped= zeros(walk_lenght,1);
Rg=  zeros(walk_lenght,1);
Ree=  zeros(walk_lenght,1);

% CICLO FOR
for n = 1 : walk_number

[XY,trapping_lenght] = GSAW2d_statistics (walk_lenght,T); 
Ree_sampling = (XY(2:end,1).^2 + XY(2:end,2).^2); %ree

% Metrics Analysis
trapped(1:trapping_lenght) = trapped(1:trapping_lenght) +1;
Ree = Ree + Ree_sampling;
end
%Normalizzazione
Ree = Ree ./trapped;
for i = 1 : walk_lenght
    Rg(i) = sqrt(std(sqrt(Ree(1: i)))^2*(i-1)/i);
end

%Taglia le code
stop=find(trapped == 0, 1);
if  isempty(stop) ==0
walk_lenght= stop-1;
end

end
