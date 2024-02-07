function  [XY,trapping_lenght,W]=GSAW2d_statistics (walk_lenght,T) 
%%
% Cosa fa?
% Riceve il parametro (intero):
% - w_lenght che è il numero di passi del GSAW
% - T peso di Boltzmann per la probabilità di un passo: e^(T*vicini)
% Da in output:
% - Ree che è la distanza testa coda al quadrato
% - Rg che è la deviazione standard dalla media dello posizioni dei diversi monomeri del polimero
%
% Basato sul paper di Wyatt Hooper and Alexander R. Klotz 
% "Trapping in Self-Avoiding Walks with Nearest-Neighbor Attraction"
%%
% DICHIARAZIONE VARIABILI 
off = 1001;
trapping_lenght = walk_lenght;
W=zeros(walk_lenght,1);
w=3/4;

% CICLO FOR FINO A N +1(punto iniziale)
XY = zeros (walk_lenght +1 ,2); %Vettore posizione
V_XY = zeros(2001,2001); %Vettore campo
V_XY(off,off) = 1;
for k = 1 : walk_lenght

% Cerca le posizioni libere intorno
    Vicini=[]; 
if V_XY( XY(k,1)+1+off, XY(k,2)+off) ~= 1 
    Vicini(end+1,:) = [XY(k,1)+1, XY(k,2) ];
end
if V_XY( XY(k,1)-1+off, XY(k,2)+off) ~= 1 
    Vicini(end+1,:) = [XY(k,1)-1, XY(k,2)];
end
if   V_XY( XY(k,1)+off, XY(k,2)+1+off) ~= 1 
    Vicini(end+1,:) = [XY(k,1), XY(k,2)+1];
end
if   V_XY( XY(k,1)+off, XY(k,2)-1+off) ~= 1 
    Vicini(end+1,:) = [XY(k,1), XY(k,2)-1];
end
[R,~] = size(Vicini);

if R == 0
    trapping_lenght = k-1; % esce da loop se finisce in una trappola
    break  
end

%PESO WALK
w=w*R/3;
W(k) = w;
destination = probability(R);  
XY(k+1,1) = Vicini(destination,1);
XY(k+1,2) = Vicini(destination,2);

% Aggiorna il campo
V_XY( XY(k+1,1)+off, XY(k+1,2)+off) = 1;

end %ciclo



function [destination] = probability(R)

        if R==1
        destination=1;

        elseif T == 0
        destination = ceil(R * rand());

        else  
        m =Vicini_dei_vicini(R);
        p1 = exp((m(1)*T));
        p2 = exp((m(2)*T));

        if R>2
        p3= exp((m(3)*T));
        else
        p3= 0;
        end

        Z = p1+p2+p3;
        p = (Z * rand());

            if   p1 > p 
            destination =1;
            elseif (p2+p1)>p && p>=p1
            destination=2;
            else
            destination=3; %primo passo in direzione obbliagata
            end  
        end
    end
   function [m] = Vicini_dei_vicini(R) 
       m = [0 0 0 0]; 
       for j = 1:R %conta le posizioni libere intorno
       if V_XY( Vicini(j,1)+1+off, Vicini(j,2)+off) == 1 
       m(j)=m(j)+1;
       end
       if V_XY( Vicini(j,1)-1+off, Vicini(j,2)+off) == 1 
       m(j)=m(j)+1;
       end
       if   V_XY( Vicini(j,1)+off, Vicini(j,2)+1+off) == 1 
       m(j)=m(j)+1;
       end
       if   V_XY( Vicini(j,1)+off, Vicini(j,2)-1+off) == 1 
       m(j)=m(j)+1;
       end
       end
 end
end


