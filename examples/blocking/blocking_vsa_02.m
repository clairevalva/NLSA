%% VSA/KOOPMAN ANALYSIS OF Z500 DATA FOR BLOCKING
%
% phi   = getDiffusionEigenfunctions( model ); -- NLSA eigenfunctions
% I think phi should be reshaped as (240, 233) but weird to interpret this i think
% z     = getKoopmanEigenfunctions( model );   -- Koopman eigenfunctions
% gamma = getKoopmanEigenvalues( model ) * 12 / (2*pi) -- Koopman eigenvalues  
% T     = getKoopmanEigenperiods( model ) / 12; -- Koopman eigenperiods
% uPhi  = getProjectedData( model ); -- Projected data onto NLSA eigenfunctons
% uZ    = getKoopmanProjectedData( model ); -- Proj. data onto Koopman eigenfunctions
% newx = getReconstructedData(model);
% Zreconstruct = getKoopmanReconstructedData(model);
%
% Koopman eigenfrequencies are the imaginary part of gamma, and are in units
% of 1/day.
%
% Koopman eigenperiods (T) are in units of day. 
%
% Modified 2021/03/18

%% DATA ANALYSIS SPECIFICATION 
tLim       = { '20120101' '20130229' };
sourceVar  = 'lwa'; % 'z500'; % 'lwa';     
embWindow  = 20;       
%kernel     = 'cone';       % cone kernel      
kernel     = 'l2';       % L2 kernel      


%% SCRIPT EXECUTION OPTIONS

% Data extraction
ifDataSource = true;  % extract source data fron netCDF files

% Spectral decomposition
ifNLSA    = true;  % compute kernel (NLSA) eigenfunctions
ifKoopman = true;  % compute Koopman eigenfunctions

% Reconstruction
ifNLSARec    = true; % do reconstruction based on NLSA
ifKoopmanRec = true;  % do reconstruction based on Koopman 

iProc = 1;
nProc = 1;
%% EXTRACT SOURCE DATA
if ifDataSource
    disp( sprintf( 'Reading source data %s...', sourceVar ) ); t = tic;
    blocking_vsa_data( sourceVar, tLim ) 
    toc( t )
end


%% BUILD NLSA MODEL, DETERMINE BASIC ARRAY SIZES
% In is a data structure containing the NLSA parameters for the training data.
%
% nSE is the number of samples avaiable for data analysis after Takens delay
% embedding.
%
% nSB is the number of samples left out in the start of the time interval (for
% temporal finite differnences employed in the kerenl).

disp( 'Building VSA model...' ); t = tic;
experiment = { sourceVar ...
               [ tLim{ 1 } '-' tLim{ 2 } ] ...
               sprintf( 'emb%i', embWindow ) ...
               [ kernel 'Kernel' ]  };
experiment = strjoin_e( experiment, '_' )

[ model, In ] = blocking_vsaModel( experiment ); 
toc( t )

nSE          = getNTotalSample( model.embComponent );
nSB          = getNXB( model.embComponent );

% Create parallel pool if running NLSA and the NLSA model has been set up
% with parallel workers. This part can be commented out if no parts of the
% NLSA code utilizing parallel workers are being executed. 
%
% In.nParE is the number of parallel workers for delay-embedded distances
% In.nParNN is the number of parallel workers for nearest neighbor search
if ifNLSA || ifNLSARec || ifKoopmanRec
    if isfield( In, 'nParE' ) && In.nParE > 0
        nPar = In.nParE;
    else
        nPar = 0;
    end
    if isfield( In, 'nParNN' ) && In.nParNN > 0
        nPar = max( nPar, In.nParNN );
    end
    if isfield( In, 'nParRec' ) && In.nParRec > 0
        nPar = max( nPar, In.nParRec );
    end
    if nPar > 0
        poolObj = gcp( 'nocreate' );
        if isempty( poolObj )
            poolObj = parpool( nPar );
        end
    end
end


%% PERFORM NLSA
if ifNLSA
    
    % Execute NLSA steps. Output from each step is saved on disk

    disp( 'Takens delay embedding...' ); t = tic; 
    computeDelayEmbedding( model )
    toc( t )

    disp( 'Phase space velocity (time tendency of data)...' ); t = tic; 
    computeVelocity( model )
    toc( t )

    disp( 'Takens delay embedding - query partition...' ); t = tic;
    computeDelayEmbeddingQ( model )
    toc( t )

    disp( 'Takens delay embedding - test partition...' ); t = tic; 
    computeDelayEmbeddingT( model )
    toc( t )

    fprintf( 'Pairwise distances for density data (%i/%i)...\n', iProc, nProc );
    t = tic;
    computeDenPairwiseDistances( model, iProc, nProc )
    toc( t )

    disp( 'Density bandwidth normalization...' ); t = tic;
    computeDenBandwidthNormalization( model );
    toc( t )

    disp( 'Density kernel sum...' ); t = tic;
    computeDenKernelDoubleSum( model )
    toc( t )

    disp( 'Density estimation...' ); t = tic;
    computeDensity( model )
    toc( t )

    disp( 'Density splitting...' ); t = tic;
    computeDensitySplitting( model )
    toc( t )

    disp( 'Density delay embedding...' ); t = tic;  
    computeDensityDelayEmbedding( model )
    toc( t )

    disp( 'Takens delay embedding for density data - query partition...' ); 
    t = tic; 
    computeDensityDelayEmbeddingQ( model )

    disp( 'Takens delay embedding for density data - test partition...' ); 
    t = tic;
    computeDensityDelayEmbeddingT( model )
    toc( t )

    fprintf( 'Pairwise distances (%i/%i)...\n', iProc, nProc ); t = tic;
    computePairwiseDistances( model, iProc, nProc )
    toc( t )

    disp( 'Distance symmetrization...' ); t = tic;
    symmetrizeDistances( model )
    toc( t )

    disp( 'Kernel tuning...' ); t = tic;
    computeKernelDoubleSum( model )
    toc( t )

    disp( 'Kernel eigenfunctions...' ); t = tic;
    computeDiffusionEigenfunctions( model )
    toc( t )
end

%% COMPUTE EIGENFUNCTIONS OF KOOPMAN GENERATOR
if ifKoopman
    disp( 'Koopman eigenfunctions...' ); t = tic;
    computeKoopmanEigenfunctions( model, 'ifLeftEigenfunctions', true )
    toc( t )
end

%% PERFORM NLSA RECONSTRUCTION
if ifNLSARec

    disp( 'Takens delay embedding...' ); t = tic; 
    computeTrgDelayEmbedding( model )
    toc( t )
    
    disp( 'Projection of target data onto kernel eigenfunctions...' ); t = tic;
    computeProjection( model )
    toc( t )

    disp( 'Reconstruction of target data from kernel eigenfunctions...' ); 
    t = tic;
    % arguments are obj, iB, iC, iR, iRec, nPar
    computeReconstruction( model, [],[], [], [], nPar  )
    toc( t )
end
    

%% PERFORM KOOPMAN RECONSTRUCTION
if ifKoopmanRec

    disp( 'Takens delay embedding...' ); t = tic; 
    computeTrgDelayEmbedding( model )
    toc( t )
    
    disp( 'Projection of target data onto Koopman eigenfunctions...' ); t = tic;
    computeKoopmanProjection( model )
    toc( t )

    disp( 'Reconstruction of target data from Koopman eigenfunctions...' ); 
    t = tic;
    computeKoopmanReconstruction( model, [],[], [], [], nPar  )
    toc( t )
end
    
