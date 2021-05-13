function [ model, In, Out ] = fastchange_z(givez)

    disp( 'Building VSA model for ' + string(givez) ); t = tic;
    experiment ='z500_20090101-20150101_emb20_l2Kernel'
    nbatch = 36;
    
    [ model, In ] = blocking_vsaModel_koopruns(experiment, givez, nbatch); 
    % 
    nSE          = getNTotalSample( model.embComponent );
    nSB          = getNXB( model.embComponent );
    toc( t )
end