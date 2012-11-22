function [A_adj, g] = simulation(A_adj, g, N, phi)
%SIMULATION Executes the simulation steps in a given network
%   Takes an adjencency matrix A_adj and an opinion vector g and also the
%   parameters N and M and phi
%   Applies iterative rules, alternating opinions and network
%   When steady state is reached: Returns network and opinion vector.

t = 0;

abort = false;      
%Boolean to stop the simulation loop. Will be set to true when convergent state is reached

%while(counter < 100000)
while(abort == false)
    
    t = t + 1;

    i = randi(N,1);     %Picking a random node i out of N nodes

    if sum(A_adj(i,:)) ~= 0     %calculate degree of ith node. If not zero (i.e. if its conncted to SOMEBODY), do following step

        i_cluster = find(A_adj(i,:));   %A vector of nodes that are connected to i (indices)
        j = i_cluster(randi(length(i_cluster)));  %Choose a random node j connected to i its neighbor to be interacted with
        %Revise this line for speed, there must be a better way  

        if rand<phi             %with probability phi, reconnect



            g_idx = find(g == g(i));  %Find nodes that have the same opinion as i and store their INDEX in a vector 
            i2 = randi(length(g_idx));  %Choose a random element from index vector g_idx,
                                      %assign the corresponding value to i2,
                                      %which is also an index of g (a node)

            %reconnect i with i2
            %Should the reconnection only occur if opinions differ?
            if A_adj(i,i2) ~= 1     %We should only reconnect if i and i2 are not already connected! Otherwise, skip step and do nothing
                                    %just to be sure we don't delete any links
                                    %Possibly find a better way to do this
                                    %I thought about a while loop looking for
                                    %alternative non-existing links, but I'd
                                    %rather not get trapped in it.

                A_adj(i,j) = 0;     %Delete "old" connection"
                A_adj(j,i) = 0;
                A_adj(i,i2) = 1;    %Add new connection
                A_adj(i2,i) = 1;
            end


        else        %If reconnection is not chosen, adjust opinions

            g(i) = g(j);  %Set opinion of i to opinion of neightbor j

        end

    end

    %%Maybe do consenus check only after each 100th or so reconnection
    %%(code above). Danger: A reconnection in a consensus state could
    %%destroy this state. Test!
    
    %Determining whether convergent state has been reached
    %If so, abort variable will be set to true and while loop is broken on the
    %next iteration
    %This mechanism seems to work, but was only tested stichprobenartig
    for i = 1:N       %Loop through all nodes     

        unequal = false;    
        %By "default" assume that there are no different opinions between
        %two neighbors. We will check all connections and set unequal to
        %true if differing opinions exist.

        for neighbor = find(A_adj(i,:));    
            %Loop through Vector of neighbors of current i (entries that are
            %non-zero --> there is a neighbor)
            if g(i) ~= g(neighbor)     
                %if the opinions are DIFFERENT break both loops and don't
                %change the abort variable since at least one neighbor has a
                %different opinion and we will continue the while loop
                unequal = true;      %Using this variable, we denote an unequal event
                                    %and break out of inner loop
                break

            end

        end

        if unequal == true      %If different opinions of neighbors were detected, also break the outer loop
            break
        end

        

    end
    
    
    if unequal == false         
        %If no different opinions of neighbors were ever detected and unequal is still false
        %--> set abort to true such that while loop will break on next
        %iteration
        abort = true;
    end



end

end

