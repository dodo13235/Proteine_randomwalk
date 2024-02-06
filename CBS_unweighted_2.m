function [occupied_neighbors,pos,bit_map]=CBS_unweighted_2(n_steps,dim)


% setting initial variables
bit_map=zeros(dim,dim,dim);
pos=zeros(n_steps,3);
x=ceil(dim/2);
y=ceil(dim/2);
z=ceil(dim/2);
pos(1,1:3)=ceil(dim/2);
bit_map(x,y,z)=1;
step=1;

occupied_neighbors=zeros(n_steps,4);
%starting to move
while(step<n_steps)


    % setting the possible neighbors
    neighbors=[x+1,y,z;
        x-1,y,z;
        x,y+1,z;
        x,y-1,z;
        x,y,z+1;
        x,y,z-1];



    % random selection of type of step
    b=rand();
    % try increase length of current walk
    if b<0.7033

        q=ceil(size(neighbors,1)*rand());
        temp_x=neighbors(q,1);
        temp_y=neighbors(q,2);
        temp_z=neighbors(q,3);

        % if the seleted destination is occupied, null move
        if   temp_x<=dim && temp_y<=dim && temp_z<=dim && temp_x>0 ...
                && temp_y>0 && temp_z>0 && bit_map(temp_x,temp_y,temp_z)==0
            x=temp_x;
            y=temp_y;
            z=temp_z;
            bit_map(x,y,z)=step+1;
            step=step+1;

        end

        pos(step,1)=x;
        pos(step,2)=y;
        pos(step,3)=z;

    else
        % delete the last position
        if step>1
            bit_map(x,y,z)=0;
            pos(step,1:3)=0;
            step=step-1;
            x=pos(step,1);
            y=pos(step,2);
            z=pos(step,3);

        end
    end

    % check if the neighbor with x+1 is occupied and different form
    % the previous and the following step; if so put it in the
    % occupied_neighbors
    step_prec=step-1;
    N=1;
    if step_prec>1
        primi_vicini=[pos(step_prec,1)+1,pos(step_prec,2),pos(step_prec,3);
            pos(step_prec,1)-1,pos(step_prec,2),pos(step_prec,3);
            pos(step_prec,1),pos(step_prec,2)+1,pos(step_prec,3);
            pos(step_prec,1),pos(step_prec,2)-1,pos(step_prec,3);
            pos(step_prec,1),pos(step_prec,2),pos(step_prec,3)+1;
            pos(step_prec,1),pos(step_prec,2),pos(step_prec,3)-1];

        for g=1:6
            if isequal(primi_vicini(g,1:3),pos(step,1:3)) || isequal(primi_vicini(g,1:3),pos(step-2,1:3))
                primi_vicini(g,1:3)=0;
            end
            for i = 1:3
                if primi_vicini(g,i)>dim || primi_vicini(g,i)==0
                    primi_vicini(g,:)=0;
                end
            end
        end

        primi_vicini=nonzeros(primi_vicini);
        primi_vicini=reshape(primi_vicini,length(primi_vicini)/3,3);

        for g=1:size(primi_vicini,1)
            if primi_vicini(g,1)<=dim && primi_vicini(g,2)<=dim && primi_vicini(g,2)<=dim ...
                    && bit_map(primi_vicini(g,1),primi_vicini(g,2),primi_vicini(g,3))~=0
                occupied_neighbors(step_prec,N)=bit_map(primi_vicini(g,1),primi_vicini(g,2),primi_vicini(g,3));
                N=N+1;
            end
        end
    end


end