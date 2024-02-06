function [idrofobicity]=Idrofobic(p_n,chain_lenght,XYZ,amm_group)
    idro_amm = [];
    non_idro_amm = [];
for i = 1:chain_lenght
    if 4 == amm_group(i)
        idro_amm = [idro_amm;XYZ(i,:,p_n)];
    % else
    %     non_idro_amm = [idro_amm;XYZ(i,:,p_n)];
    end
end
    if (isempty(idro_amm) && isempty(non_idro_amm)) == 0
    %Rg_idro=std(sqrt(idro_amm(:,1).^2 + idro_amm(:,2).^2 +idro_amm(:,3).^2 )); % piccolo = buono
    Cm =  [mean(XYZ(:,1,p_n)),mean(XYZ(:,2,p_n)),mean(XYZ(:,3,p_n))];
    
    dist_cm = (idro_amm-Cm).^2;
    Std_dist_cm = mean(dist_cm(:,1) +dist_cm(:,2)+ dist_cm(:,3)); % piccolo = buono
    idrofobicity  = sqrt(1/(Std_dist_cm));
    else
        disp("not enough amminoacid types")
        idrofobicity = 0;
    end
end