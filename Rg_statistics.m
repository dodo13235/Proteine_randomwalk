function Rg_statistics (walk_start,walk_lenght,walk_number,T)
%% 
% Vengono usati due metodi diversi per dimostrare che il gyration radius
% va come:  Rg ~ N^(v) con  v = 2/3 
% L'analisi dati parte dal ventesimo step (perchè all'inizio v non è stabile)
% Riceve in input
% 1) start step
% 2) end step
% 3) numero simulaioni
% 4) temperatura 
%%
%calcola i valori statistici
local_approx();

linear_approx();

function local_approx()
%Rg con formula -> Primo modo
% Trova v medio approssimando localmente a ogni passo
% fa due cicli per stimare la deviazione standard dalla media
% calcolandola si con che senza un peso
mean_down = zeros(100,1);
mean_down_w = zeros(100,1);
v_up = zeros(walk_lenght-walk_start,1);
w_up =zeros(walk_lenght-walk_start,1);

for j = 1:100
  [stop,~,~,Rg,trapped,~,~]=Many_GSAW2d_statistics (walk_lenght,walk_number,T);
  w_down = trapped(walk_start:(stop-1))/walk_number; % peso arbitrario
  v_down = zeros(stop-1,1);

  for n = walk_start : stop-1
    v_down(n) = (log(Rg(n+1) )-log(Rg( (n-1) ) ) )/(log(n+1)-log(n-1));
  end

  v_down=v_down(walk_start:end); %scarta i punti iniziali 
  mean_down(j) = mean(v_down);
  mean_down_w(j) = sum(v_down.*w_down, "all") / sum(w_down, "all");
  v_up(1:stop-walk_start)= v_down.*w_down + v_up(1:stop-walk_start);
  w_up(1:stop-walk_start)= w_up(1:stop-walk_start) +w_down;
  
  %fprintf("step number %g/100 \n",j)
end


v_up = v_up./w_up; % normalizza
mean_up=mean(mean_down);
mean_up_w=mean(mean_down_w);%media pesata
std_up=std(mean_down);
std_up_w=std(mean_down_w);

%PLOT
figure ( 2 );
plot ( walk_start:(walk_lenght-1),v_up, ".");
hold on
plot(walk_start:(walk_lenght-1),ones(walk_lenght-walk_start,1)*mean_up_w,"r-")
hold off
xlabel ( 'N' );
ylabel ( 'v' );
ylim([0 0.7])
title ( 'exponential coefficent for the walk Rg' );

fprintf ( 'The mean is: v_mean = %g(+-%g) \n',mean_up,std_up)
fprintf ( 'The weighted mean is: v_mean = %g(+-%g) \n',mean_up_w,std_up_w)
end

function linear_approx()
[walk_lenght,~,~,Rg,~,~,~]=Many_GSAW2d_statistics (walk_lenght,walk_number*100,T);
    
%Rg con fit lineare -> secondo modo
% la slope della retta da 2v
N= 1:walk_lenght;
R_log=zeros(walk_lenght-walk_start,1);
N_log=zeros(walk_lenght-walk_start,1);

% passiamo ai logaritmi scartando l'ultimo step e i primi fino a walk start
for i = walk_start : (walk_lenght-1) 
    R_log(i-walk_start+1) = log ( Rg(i) );
    N_log(i-walk_start+1) = log ( N(i) );
end

f = fit(N_log,R_log,'poly1',"Weights",ones(walk_lenght-walk_start,1));

%PLOT
figure ( 3 );
plot (f,N_log, R_log,'*')
xlabel ( 'log(N)' );
ylabel ( 'log(Rg)' );
title ( 'log(<Rg>) versus log(N)' );

errors = confint(f); errors = abs((errors(:, 2) - errors(:, 1)) / 2);
fprintf ( 'The least squares fit gives: log(Rg) = %g(+-%g)*log(step) + %g(+-%g) \n', f.p1,errors(1), f.p2, errors(2) )
end


end