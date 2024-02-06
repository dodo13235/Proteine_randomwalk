%%
% p_n -> plot number
% r -> raggio sfere
function plotSpheres(p_n,r,chain_lenght,amm_group,XYZ)

[X,Y,Z] = sphere;
X = X * r; Y = Y * r; Z = Z * r;
washeld = ishold();
colour=zeros(chain_lenght,3);
colour_n = [1 0 0;...
            0 0 1 ;...
            0 1 0 ;...
            1 1 0 ];
for i =  1:chain_lenght

    colour(i,:) = colour_n(amm_group(i),:);
end

plot3(XYZ(:,1,p_n),XYZ(:,2,p_n),XYZ(:,3,p_n))
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on
title(sprintf('Walk N. = %d', p_n))
hold on;

for i = 1:chain_lenght
    s1 = surf(X+XYZ(i,1,p_n),Y+XYZ(i,2,p_n),Z+XYZ(i,3,p_n));
    set(s1,'Facecolor',colour(i,:),'EdgeColor', 'none');

end
axis equal
plot3(XYZ(end,1,p_n),XYZ(end,2,p_n),XYZ(end,3,p_n), 'mX', 'MarkerSize', 10);
if ~washeld
    hold off
end
lighting phong

end


