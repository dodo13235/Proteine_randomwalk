function [Energy,XYZ] = Energy(amm_group,chain_lenght)
%%
% Calcola l'energia di una configurazione
%%
% XYZ -> array posizioni
 Energy = 0;
[neighbors,XYZ] = CBS_unweighted_2(chain_lenght,6);

for j = 1:chain_lenght
    point = j;
    Energy = Energy + local_energy(point);
end


    function [local_energy] = local_energy(point)
        % calcola le energie reciproche locali fra i 4 gruppi di
        % amminoacidi seconda la proporzionalità reciproca
        %[neighbors,n_neighbours,isolate] = neighbors_generator(point);
        neighbors_local = nonzeros(neighbors(point,:))';
        local_E = zeros(length(neighbors_local),1);
        
        if isempty(neighbors_local) == 1
            local_energy =0;
            return
        end

        %sceglie solo le posizioni occupate da amminoacidi tra i vicini e
        %assegna il gruppo corrispondente
        neighbors_group = group(neighbors_local);
        point_group = group(point);

        for i = 1 : length(neighbors_local) % enumera i 10 casi possibili
            neighbor_group =neighbors_group(i);

            % ione-ione 1000; ione-polare 500; polare-polare 400; idro-idro 400
            % 1 per acido, 2 per base, 3 per polare e 4 per idrofobico.
            if (neighbor_group == 1 && point_group == 2) || ...    %n.1
                    (point_group == 1 && neighbor_group == 2)
                local_E(i) = -1000;
            elseif (neighbor_group == 1 && point_group == 3) || ...%n.2
                    (point_group == 1 && neighbor_group == 3)
                local_E(i) = -500 ;
            elseif (neighbor_group == 1 && point_group == 1)       %n.4
                local_E(i) = 1000;
            elseif (neighbor_group == 2 && point_group == 3) || ...%n.5
                    (point_group == 2 && neighbor_group == 3)
                local_E(i) = -500;
            elseif (neighbor_group == 2 && point_group == 2)       %n.7
                local_E(i) = 1000;
            elseif (neighbor_group == 3 && point_group == 3)       %n.9
                local_E(i) = -400;
            elseif (neighbor_group == 4 && point_group == 4)       %n.10
                local_E(i) = -400;
            else
                local_E(i) = 0;
            end
        end
        local_energy = sum(local_E);


    end


    function [point_group] = group(n_point)
        % restituise il gruppo di appartenenza per ogni elemento dell'array
        % controllando in un database.
        % Questi numeri rappresentano i gruppi funzionali principali a cui
        % appartengono gli amminoacidi
        point_group = zeros(length(n_point),1);
  
        for i = 1: length(n_point)
            point_group(i) = amm_group(n_point(i));
        end
    end
end
