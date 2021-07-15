%rrr = 1; % set index of rec list
rec_list = {[5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [18], [17], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31], [32]};
batch_list = [36, 48]; % also 48, 36??
t = tic; 
try
    rec_list(rrr)
    [ model, In ] = fastchange_z(rec_list(rrr), batch_list(1));
    zreconstruct = getKoopmanReconstructedData(model);
    
catch
    [ model, In ] = fastchange_z(rec_list(rrr), batch_list(2));
    zreconstruct = getKoopmanReconstructedData(model);
    
end
phiname = rec_list(rrr);
disp("total time: ")
toc( t )
%plot_arr = reshape(newx, 41, [], 240);