%rrr = 1; % set index of rec list
rec_list = {[5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [18], [17], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31], [32]};
rec_list2 = [5:31];
t = tic; 

[ model, In ] = fastchange_z(rec_list(rrr));
zreconstruct = getKoopmanReconstructedData(model);

%phiname = rec_list(rrr);
disp("total time: ")
toc( t )
%plot_arr = reshape(newx, 41, [], 240);