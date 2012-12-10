%%This is a simple a data-plotter of data generated by main_script.m

N_range = [100 200 300 500];           %Choose curves to be compared
%k_range = [4 8];                %Choose curves to be compared
col=hsv(length(N_range));       %Creates as many colors as there are curves to be plotted
j=1;                            %Manually create integer counter for the Phi-loop
legcell=cell(1,length(N_range));%Create string cell for legend in graph

filelisting = dir(fullfile('Data', '*.mat'));   %Create list of .mat files in directory

for N2read = N_range             %Choose curves to be compared
    %k_avg_set = k_range 
    %Make sure to comment the variable that is varied in the loop. These
    %variables are merely necessary for reading the proper data and not
    %used for caculations.
    
    %N = 500;
    k_avg_set = 4;
    gamma = 10;
    ii = 100;
    Var_tau = [];
    phi_local = [];
    
    %This loop extracts the order parameter op from each data set and puts
    %it into op_local. Also extracts phi correspondingly

    for file_idx = 1:length(filelisting)    %Create index running up until the number of files in the directory
 
        load(['Data/' filelisting(file_idx).name]);        %Load data of file at this index
        if N == N2read                                     %If N is the N we are reading right now, add phi and op to local vectors
            phi_local = [phi_local phi];
            Var_tau = [Var_tau mean(tt)/N]; %Concatenate the value of the size of the biggest cluster for a given phi. The command finds the 1 last non-zero entry of s.
        end
    end
    
    %Plot curves into graph that is held open.
    plot(phi_local, Var_tau, 'o','color',col(j,:)) 
    legcell{j}=['N = ',num2str(N2read)]; %Create cell for data range (e.g. N_range or k_range)
    j=j+1;      %Manually increment loop counter. This is just for getting different colors in the plot.
    hold on;
end
hold off;   

%%Add labels and legend to graph
xlabel('Reconnection probability \Phi');
ylabel('Average convergence time   \tau');
legend(legcell);
grid on;