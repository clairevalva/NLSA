% DEMO OF KERNEL ANALOG FORECAST (KAF) OF THE LORENZ 63 (L63) SYSTEM 
% 
% This script applies KAF to predict the state vector compoents of the L63 
% system under full or partial observations.
%
% Two test cases are provided, illustrating the behavior of the method when
% the covariate data is the x1 component of the state vector component alone,
% or the full state vector. In addition, we consider an example where the 
% covariate data of the partially observed system is augmented using delay-
% coordinate maps, illustrating the recovery of forecast skill as expected
% from "Embedology" results.
% 
% Each test case has variants utiilizing 6400 or 64000 training samples, taken
% near thee L63 attractor at a sampling interval dt of 0.01 natural time 
% units.  These experiments are selected using a character variable 
% experiments which can take the following values:
%
% '6.4k_dt0.01_idxX1_2_3_nEL0': 6400 samples, dt=0.01, fully observed, 0 delays 
% '6.4k_dt0.01_idxX_nEL0': 6400 samples, dt=0.01, x1 only, 0 delays 
% '6.4k_dt0.01_idxX_nEL10': 6400 samples, dt=0.01, x1 only, 10 delays 
% '64k_dt0.01_idxX1_2_3_nEL0': 64000 samples, dt=0.01, fully observed, 0 delays 
% '64k_dt0.01_idxX_nEL0': 64000 samples, dt=0.01, x1 only, 0 delays 
% '64k_dt0.01_idxX_nEL10': 64000 samples, dt=0.01, x1 only, 10 delays 
%
% The kernel employed is a variable-bandwidth Gaussian kernel, normalized to a
% symmetric Markov kernel. This requires a kernel density estimation step to
% compute the bandwidth functions, followed by a normalization step to form the
% kernel matrix. See pseudocode in Appendix B of reference [2] below for 
% further details. 
%
% References:
% 
% [1] R. Alexander, D. Giannakis (2020), "Operator-theoretic framework for 
%     forecasting nonlinear time series with kernel analog techniques", 
%     Phys. D, 409, 132520, https://doi.org/10.1016/j.physd.2020.132520. 
%
% [2] S. Das, D. Giannakis, J. Slawinska (2018), "Reproducing kernel Hilbert
%     space compactification of unitary evolution groups", 
%     https://arxiv.org/abs/1808.01515.
%
% Modified 2020/08/08

%% EXPERIMENT SPECIFICATION AND SCRIPT EXECUTION OPTIONS
experiment = '6.4k_dt0.01_idxX1_2_3_nEL0';
%experiment = '6.4k_dt0.01_idxX_nEL0';
%experiment = '6.4k_dt0.01_idxX_nEL10'; 
%experiment = '64k_dt0.01_idxX1_2_3_nEL0';
%experiment = '64k_dt0.01_idxX_nEL0';
%experiment = '64k_dt0.01_idxX_nEL10'; 

ifSourceData   = false; % generate source data
ifTestData     = false; % generate test (verification) data
ifNLSA         = false; % run NLSA (kernel eigenfunctions)
ifOse          = false; % do out-of-sample extension of eigenfunctions
ifReadKAFData  = false; % read training/test data for KAF
ifKAF          = true;  % perform KAF 
ifPlotForecast = true; % plot representative forecast trajectories
ifPlotError    = true; % plot forecast error
ifPrintFig     = true; % print figures to file

%% BATCH PROCESSING
iProc = 1; % index of batch process for this script
nProc = 1; % number of batch processes

%% GLOBAL PARAMETERS
% nL:         Number of eigenfunctions to use for KAF target function
% nT:         Number of timesteps to predict (including 0)
% idxTPlt:    Initial conditions for which to plot forecast trajectories
% figDir:     Output directory for plots
% markerSize: For eigenfunction scatterplots

switch experiment

case '6.4k_dt0.01_idxX1_2_3_nEL0'
    nL = 501;
    nT = 501; 
    idxTPlt = [ 2101 2201 2301 ];
    markerSize = 7;         
    tStr = '6.4k, full obs.';

case '6.4k_dt0.01_idxX1_nEL0'
    nT = 501; 
    idxTPlt = [ 2000 3000 ];
    signZPlt = [ 1 -1 ];   
    markerSize = 7;         
    signPC     = [ -1 1 ];

otherwise
    error( 'Invalid experiment.' )
end


% Figure/movie directory
figDir = fullfile( pwd, 'figsKAF', experiment );
if ifPrintFig && ~isdir( figDir )
    mkdir( figDir )
end

%% EXTRACT SOURCE DATA
if ifSourceData
    disp( 'Generating source data...' ); t = tic;
    demoKAF_data( experiment ) 
    toc( t )
end

%% EXTRACT TEST DATA
if ifTestData
    disp( 'Generating test data...' ); t = tic;
    demoKAF_test_data( experiment ) 
    toc( t )
end


%% BUILD NLSA MODEL, DETERMINE BASIC ARRAY SIZES
% In and Out are data structures containing the NLSA parameters for the 
% training and test data, respectively.
%
% idxT1 is the initial time stamp in the covariante data ("origin") where 
% delay embedding is performed. We remove samples 1 to idxT1 from the response
% data so that they always lie in the future of the delay embedding window.
disp( 'Building NLSA model...' ); t = tic;
[ model, In, Out ] = demoKAF_nlsaModel( experiment ); 
toc( t )

idxT1 = getOrigin( model.embComponent );

% Create parallel pool if running NLSA and the NLSA model has been set up
% with parallel workers. This part can be commented out if no parts of the
% NLSA code utilizing parallel workers are being executed. 
%
% In.nParE is the number of parallel workers for delay-embedded distances
% In.nParNN is the number of parallel workers for nearest neighbor search
if ifNLSA
    if isfield( In, 'nParE' ) && In.nParE > 0
        nPar = In.nParE;
    else
        nPar = 0;
    end
    if isfield( In, 'nParNN' ) && In.nParNN > 0
        nPar = max( nPar, In.nParNN );
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
    
    % Execute NLSA steps. Output from each step is saved on disk.

    disp( 'Takens delay embedding...' ); t = tic; 
    computeDelayEmbedding( model )
    toc( t )


    fprintf( 'Pairwise distances for density data, %i/%i...\n', iProc, nProc ); 
    t = tic;
    computeDenPairwiseDistances( model, iProc, nProc )
    toc( t )

    disp( 'Distance normalization for kernel density steimation...' ); t = tic;
    computeDenBandwidthNormalization( model );
    toc( t )

    disp( 'Kernel bandwidth tuning for density estimation...' ); t = tic;
    computeDenKernelDoubleSum( model );
    toc( t )

    disp( 'Kernel density estimation...' ); t = tic;
    computeDensity( model );
    toc( t )

    disp( 'Takens delay embedding for density data...' ); t = tic;
    computeDensityDelayEmbedding( model );
    toc( t )

    fprintf( 'Pairwise distances (%i/%i)...\n', iProc, nProc ); t = tic;
    computePairwiseDistances( model, iProc, nProc )
    toc( t )

    disp( 'Distance symmetrization...' ); t = tic;
    symmetrizeDistances( model )
    toc( t )

    disp( 'Kernel bandwidth tuning...' ); t = tic;
    computeKernelDoubleSum( model )
    toc( t )

    disp( 'Kernel eigenfunctions...' ); t = tic;
    computeDiffusionEigenfunctions( model )
    toc( t )

end

%% DO OUT-OF-SAMPLE EXTENSIONS
if ifOse
    
    disp( 'Takens delay embedding for out-of-sample data...' ); t = tic;
    computeOutDelayEmbedding( model )
    toc( t )

    fprintf( 'OSE pairwise distances for density data... %i/%i\n', iProc, ...
        nProc ); t = tic;
    computeOseDenPairwiseDistances( model, iProc, nProc )
    toc( t )

    disp( 'OSE density bandwidth normalization...' ); t = tic;
    computeOseDenBandwidthNormalization( model )
    toc( t )

    disp( 'OSE kernel density estimation...' ); t = tic;
    computeOseDensity( model )
    toc( t )

    disp( 'OSE density delay embedding...' ); t = tic; 
    computeOseDensityDelayEmbedding( model );
    toc( t )

    fprintf( 'OSE pairwise distances... %i/%i\n', iProc, nProc ); t = tic; 
    computeOsePairwiseDistances( model, iProc, nProc )
    toc( t )

    disp( 'OSE kernel normalization...' ); t = tic;
    computeOseKernelNormalization( model )

    disp( 'OSE kernel degree...' ); t = tic;
    computeOseKernelDegree( model )
    toc( t )

    disp( 'Nystrom operator...' ); t = tic;
    computeOseDiffusionOperator( model )
    toc( t )

    disp( 'OSE diffusion eigenfunctions...' ); t = tic;
    computeOseDiffusionEigenfunctions( model )
    toc( t )
end

%% READ TRAINING AND TEST DATA FOR KAF
% y is an array of size [ 3 nSY ] containing in its columns the response 
% variable (3-dimensional L63 state vector) on the training states. nSY is
% the number of response samples available after delay embedding.
%
% phi is an array of size [ nSX nPhi ] whose columns contain the eigenfunctions
% from NLSA on the training states. nSX is the number of covariate samples
% available after delay embedding, and nPhi the number of eigenfunctions 
% available from the nlsaModel. nSX is less than or equal to nSY.  
%
% yO is an array of size [ 3 nSO ] containing in its columns the response
% variable on the test states. nSO is the number of test samples available
% after delay embedding.
%
% phiO is an array of size [ nSO nPhi ] containing the out-of-sample values
% of the NLSA eigenfunctions.
if ifReadKAFData
    tic
    disp( 'Retrieving KAF data...' ); t = tic;
    
    % Response variable
    y = getData( model.trgComponent );
    y = y( :, idxT1 : end );

    % Eigenfunctions 
    [ phi, mu ] = getDiffusionEigenfunctions( model ); 

    % Response variable (test data)
    yO = getData( model.outTrgComponent );
    yO = yO( :, idxT1 : end );

    % Eigenfunctions (test data)
    phiO = getOseDiffusionEigenfunctions( model );
    toc( t )
end

%% PERFORM KAF
if ifKAF
    tic 
    disp( 'Performing KAF...' ); t = tic;
    yT = analogForecast( y, phi( :, 1 : nL ), mu, phiO( :, 1 : nL ), nT );
    toc( t )

    tic
    disp( 'Computing forecast error...' ); t = tic;
    [ ~, yRMSE, yPC ] = forecastError( yO, yT );
    yRMSE = yRMSE ./ std( y, 0, 2 );
    toc( t )
end

%% PLOT FORECAST TRAJECTORIES
if ifPlotForecast

    % Lead times
    t = ( 0 : nT - 1 ) * In.dt; 

    % Plot limits and ticks
    yLm = [ [ -25 -25 5 ]' [ 25 25 50 ]' ]; 
    yTk = { -20 : 10 : 20, -20 : 10 : 20, 10 : 10 : 50 }; 
   
    % Set up figure and axes 
    Fig.nTileX     = 3;
    Fig.nTileY     = numel( idxTPlt );
    Fig.units      = 'inches';
    Fig.figWidth   = 8; 
    Fig.deltaX     = .6;
    Fig.deltaX2    = .15;
    Fig.deltaY     = .5;
    Fig.deltaY2    = .3;
    Fig.gapX       = .4;
    Fig.gapY       = .3;
    Fig.gapT       = 0.32; 
    Fig.aspectR    = 3 / 4;
    Fig.fontName   = 'helvetica';
    Fig.fontSize   = 10;
    Fig.tickLength = [ 0.02 0 ];
    Fig.visible    = 'on';
    Fig.nextPlot   = 'add'; 

    [ fig, ax, axTitle ] = tileAxes( Fig );

    % Plot skill scores
    for iT = 1 : Fig.nTileY; 

        % Initialization time, true and forecast signal
        t0 = ( idxTPlt( iT ) - 1 ) * In.dt;
        yTrue = yO( :, idxTPlt( iT ) : idxTPlt( iT ) + nT - 1 );
        yPred = squeeze( yT( :, :, idxTPlt( iT ) ) );


        % Loop over the components of the response vector
        for iY = 1 : 3
            set( gcf, 'currentAxes', ax( iY, iT ) )
            plot( t, yTrue( iY, : ), 'k-' )
            plot( t, yPred( iY, : ), 'b-' )

            xlim( [ t( 1 ) t( end ) ] )
            ylim( yLm( iY, : ) )
            set( gca, 'xTick', t( 1 ) : 1 : t( end ), ...
                      'yTick', yTk{ iY } )  
            grid on

            if iY == 1
                ylabel( sprintf( 'Init. time t_0 = %1.1f', t0 ) )
            end
            if iT == 1
                title( sprintf( 'x_{%i}', iY ) )
            end
            if iT == Fig.nTileY
                xlabel( 'Lead time t' ) 
            else
                set( gca, 'xTickLabel', [] )
            end
            if iT == 1 && iY == 1
                legend( 'true', 'forecast', 'location', 'northwest' )
            end
        end
    end


    % Add figure title
    titleStr = sprintf( '%s, number of basis functions = %i', tStr, nL );
    title( axTitle, titleStr )
            

    % Print figure
    if ifPrintFig
        figFile = sprintf( 'figForecastTrajectory_nL%i.png', nL );
        figFile = fullfile( figDir, figFile );
        print( fig, figFile, '-dpng', '-r300' ) 
    end

end

%% PLOT ERROR SCORES
if ifPlotError

    % Lead times
    t = ( 0 : nT - 1 ) * In.dt; 

    % Set up figure and axes 
    Fig.nTileX     = 3;
    Fig.nTileY     = 2;
    Fig.units      = 'inches';
    Fig.figWidth   = 8; 
    Fig.deltaX     = .6;
    Fig.deltaX2    = .15;
    Fig.deltaY     = .5;
    Fig.deltaY2    = .3;
    Fig.gapX       = .3;
    Fig.gapY       = .3;
    Fig.gapT       = 0.32; 
    Fig.aspectR    = 3 / 4;
    Fig.fontName   = 'helvetica';
    Fig.fontSize   = 10;
    Fig.tickLength = [ 0.02 0 ];
    Fig.visible    = 'on';
    Fig.nextPlot   = 'add'; 

    [ fig, ax, axTitle ] = tileAxes( Fig );

    % Plot skill scores
    for iY = 1 : 3 

        % Normalized RMSE
        set( gcf, 'currentAxes', ax( iY, 1 ) )
        plot( t, yRMSE( iY, : ) )

        grid on
        ylim( [ 0 1.2 ] )
        xlim( [ t( 1 ) t( end ) ] )
        set( gca, 'xTick', t( 1 ) : 1 : t( end ), 'yTick', 0 : .2 : 1.2, ...
                  'xTickLabel', [] )  
        if iY == 1
            ylabel( 'Normalized RMSE' )
        else
            set( gca, 'yTickLabel', [] )
        end
        title( sprintf( 'x_{%i}', iY ) )
        
        % Pattern correlation
        set( gcf, 'currentAxes', ax( iY, 2 ) )
        plot( t, yPC( iY, : ) )

        grid on
        ylim( [ -0.2 1.1 ] )
        xlim( [ t( 1 ) t( end ) ] )
        set( gca, 'xTick', t( 1 ) : 1 : t( end ), 'yTick', -0.2 : .2 : 1.2 )  
        if iY == 1
            ylabel( 'Pattern correlation' )
        else
            set( gca, 'yTickLabel', [] )
        end
        xlabel( 'Lead time t' ) 
    end

    % Add figure title
    titleStr = sprintf( '%s, number of basis functions = %i', tStr, nL );
    title( axTitle, titleStr )

    % Print figure
    if ifPrintFig
        figFile = sprintf( 'figForecastError_nL%i.png', nL );
        figFile = fullfile( figDir, figFile );
        print( fig, figFile, '-dpng', '-r300' ) 
    end
end
        






         


