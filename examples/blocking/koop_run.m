function [ model, In, Out ] = koop_run(givez)


    % while i could just fix the code bug, that is wayyy to much work
    
    experiment ='z500_20090101-20150101_emb20_l2Kernel'
    nbatch = 36;
    % givephi = [5];
    % nbatch could will be 36
    
    [ model, In ] = blocking_vsaModel_koopruns(experiment, givez, nbatch); 

    % 
    nSE          = getNTotalSample( model.embComponent );
    nSB          = getNXB( model.embComponent );
    iProc = 1;
    nProc = 1;
    nPar = 0;


    disp( 'Reconstruction of target data from Koopman eigenfunctions...' ); 
    t = tic;
    computeKoopmanReconstruction( model, [],[], [], [], nPar  )
    toc( t )
    end