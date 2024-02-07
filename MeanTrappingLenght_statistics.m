function MeanTrappingLenght_statistics (walk_lenght,walk_number_up,walk_number_down)
%% Calcola la distanza media percorsa
%%
%PARAMETRI DI CONTROLLO
T_max = 0.6;
T_min=0;
step=0.01;

% DICHIARAZIONE VARIABILI
mean_up = zeros((T_max-T_min)/step+1,1);
std_up = zeros((T_max-T_min)/step+1,1);
mean_down = zeros(walk_number_up,1);

for T = T_min:step:T_max
    parfor j  = 1 :walk_number_up
    trapped = zeros(walk_number_down,1);
       for i = 1 : walk_number_down
       [~,trapping_lenght,~]=GSAW2d_statistics (walk_lenght,T);
       trapped(i) = trapping_lenght;
       end
     mean_down(j) = mean(trapped);
    end
    mean_up(int32(T/step+1)) = mean(mean_down);
    std_up(int32(T/step+1)) = std(mean_down)/sqrt(100);
    T
end
figure(1)
errorbar ((T_min:step:T_max)',mean_up,std_up,"o")
xlabel ("Boltmann factor")
ylabel("Mean trapping lenght")
end