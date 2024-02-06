function [group,chain_lenght] = amm_to_group(amm)
    % Inizializza un vettore per memorizzare i gruppi corrispondenti agli amminoacidi
    amm=split(amm,"");
    amm=amm(2:end-1);
    chain_lenght=length(amm);
    group = zeros(chain_lenght,1);
    
    % Itera attraverso gli amminoacidi
    for i = 1:chain_lenght
        % Assegna il gruppo in base alla lettera dell'amminoacido
        switch amm(i)
            case {'D', 'E'}
                group(i) = 1; % Acido
            case {'K', 'R', 'H'}
                group(i) = 2; % Base
            case {'N', 'Q', 'S', 'T', 'C', 'Y'}
                group(i) = 3; % Polare
            case {'A', 'G', 'I', 'L', 'M', 'F', 'W', 'V', 'P'}
                group(i) = 4; % Idrofobico
            otherwise
                disp('Lettera non valida');
                return;
        end
    end
end

    
% | Aminoacido | Gruppo di Appartenenza |
% |------------|------------------------|
% | Acido Aspartico (D) | Acido   |
% | Acido Glutammico (E) | Acido   |
% | Lisina (K)     | Basico                  |
% | Arginina (R)   | Basico                  |
% | Istidina (H)   | Basico                  |
% | Asparagina (N) | Polare                  |
% | Glutammina (Q) | Polare                  |
% | Serina (S)     | Polare                  |
% | Treonina (T)   | Polare                  |
% | Cisteina (C)   | Polare                  |
% | Tirosina (Y)   | Polare                  |
% | Alanina (A)    | Apolare                 |
% | Glicina (G)    | Apolare                 |
% | Isoleucina (I) | Apolare                 |
% | Leucina (L)    | Apolare                 |
% | Metionina (M)  | Apolare                 |
% | Fenilalanina (F) | Apolare               |
% | Triptofano (W) | Apolare                 |
% | Valina (V)     | Apolare                 |
% | Prolina (P)    | Apolare                 |

