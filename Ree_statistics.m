function Ree_statistics (walk_start,walk_lenght,walk_number,T)
%% 
% Vengono usati due metodi diversi per dimostrare che il l'end to end
% distance va come:  Ree^2 ~ N^(v) con v = 3/2
% Riceve in input
% 1) start step
% 2) end step
% 3) numero simulaioni
% 4) temperatura
%%
%calcola i valori statistici

%local_approx();

linear_approx();


function local_approx()

%Ree con formula -> Primo modo
% Trova 2v medio approssimando localmente a ogni passo
% calcola la media pesata per questo valore e la sua deviazione standard
% campionando 100 volte
mean_down = zeros(100,1);
v_up = zeros(walk_lenght-walk_start,1);
w_up =zeros(walk_lenght-walk_start,1);
for j = 1:100
  [stop,~,Ree,~,trapped,~,~]=Many_GSAW2d_statistics (walk_lenght,walk_number,T);
  w_down = trapped(walk_start:(stop-1))/walk_number;
  v_down = zeros(stop-1,1);

  for n = walk_start : stop-1
    v_down(n) = (log(Ree(n+1) )-log(Ree( (n-1) ) ) )/(log(n+1)-log(n-1));
  end

  v_down=v_down(walk_start:end); %scarta i punti iniziali 
  mean_down(j) = sum(v_down.*w_down, "all") / sum(w_down, "all");
  v_up(1:stop-walk_start)= v_down.*w_down + v_up(1:stop-walk_start);
  w_up(1:stop-walk_start)= w_up(1:stop-walk_start) +w_down;
   
  %fprintf("step numero %g/100 \n",j)
end


v_up = v_up./w_up; % normalizza
mean_up=mean(mean_down);
std_up=std(mean_down);

%PLOT
figure ( 2 );
plot ( walk_start:(walk_lenght-1),v_up, ".");
hold on
plot(walk_start:(walk_lenght-1),ones(walk_lenght-walk_start,1)*mean_up,"r-")
hold off
xlabel ( 'N' );
ylabel ( 'v' );
ylim([0 3])
title ( '2*exponential coefficent for the walk Ree' );

fprintf ( 'The weighted mean is: v^2 = %g(+-%g) \n',mean_up,std_up)
end


function linear_approx()
[walk_lenght,~,Ree,~,~,~,~]=Many_GSAW2d_statistics (walk_lenght,walk_number,T);
    
%Ree con fit lineare -> secondo modo
% la slope della retta da 2v
N= 1:walk_lenght;
R_log=zeros(walk_lenght-walk_start,1);
N_log=zeros(walk_lenght-walk_start,1);

% passiamo ai logaritmi scartando l'ultimo step e i primi fino a walk start
for i = walk_start : (walk_lenght-1) 
    R_log(i-walk_start+1) = log ( Ree(i) );
    N_log(i-walk_start+1) = log ( N(i) );
end

f = fit(N_log,R_log,'poly1',"Weights",ones(walk_lenght-walk_start,1));

%PLOT
figure ( 3 );
plot (f,N_log, R_log,'*')
xlabel ( 'log(N)' );
ylabel ( 'log(D^2)' );
title ( 'log(<d^2>) versus log(N)' );

errors = confint(f); errors = abs((errors(:, 2) - errors(:, 1)) / 2);
fprintf ( 'The least squares fit gives: log(Ree^2) = %g(+-%g)*log(step) + %g(+-%g) \n', f.p1,errors(1), f.p2, errors(2) )
end

end