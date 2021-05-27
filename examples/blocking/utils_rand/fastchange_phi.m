function [ model, In, Out ] = fastchange_phi(givephi, nbatch)


% while i could just fix the code bug, that is wayyy to much work
t = tic;
experiment ='z500_20090101-20150101_emb20_l2Kernel'
% givephi = [5];
% nbatch could be 48, or 36
[ model, In ] = blocking_vsaModel_test(experiment, givephi, nbatch); 
% 
nSE          = getNTotalSample( model.embComponent );
nSB          = getNXB( model.embComponent );
toc( t )
end