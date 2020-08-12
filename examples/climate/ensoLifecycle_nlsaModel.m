function [ model, In, Out ] = ensoLifecycle_nlsaModel( experiment )
% ENSOLIFECYCLE_NLSAMODEL Construct NLSA model for analysis of ENSO lifecycle
% 
% Input arguments:
%
% experiment: A string identifier for the data analysis experiment. 
%
% Output arguments:
%
% model: Constructed model, in the form of an nlsaModel object.  
% In:    Data structure with in-sample model parameters. 
% Out:   Data structure with out-of-sample model parameters (optional). 
%
% This function creates the parameter structures In and Out, which are then 
% passed to function climateNLSAModel to build the model.
%
% The constructed NLSA models have the following target components (used for
% composite lifecycle analysis):
%
% Component 1:  Nino 3.4 index
% Component 2:  Nino 4 index
% Component 3:  Nino 3 index
% Component 4:  Nino 1+2 index
% Component 5:  Global SST anomalies 
% Component 6:  Global SSH anomalies
% Component 7:  Global SAT anomalies
% Component 8:  Global precipitation rates
% Component 9:  Global surface zonal winds
% Component 10: Global surface meridional winds
% 
% Modified 2020/05/19

if nargin == 0
    experiment = 'ersstV4_50yr_IPSST_4yrEmb_coneKernel';
end

switch experiment

% NOAA 20th Century Reanalysis, industrial era, Indo-Pacific SST input,
% 4-year delay embeding window, cone kernel  
case '20CR_industrial_IPSST_4yrEmb_coneKernel'
   
    % Dataset specification  
    In.Res( 1 ).experiment = '20CR';                

    % Time specification
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '187001' '201906' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 28 290 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -60  20 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 1;          % samples before main interval
    In.Src( 1 ).nXA       = 0;          % samples after main interval
    In.Src( 1 ).fdOrder   = 1;          % finite-difference order 
    In.Src( 1 ).fdType    = 'backward'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 1;          % samples before main interval
    In.Src( 1 ).nXA       = 0;          % samples after main interval
    In.Src( 1 ).fdOrder   = 1;          % finite-difference order 
    In.Src( 1 ).fdType    = 'backward'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 501;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection

% NOAA 20th Century Reanalysis, approximate satellite era, Indo-Pacific SST 
% input, 4-year delay embeding window  
case '20CR_satellite_IPSST_4yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = '20CR';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197001' '201906' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 28 290 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -60  20 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 1;          % samples before main interval
    In.Src( 1 ).nXA       = 0;          % samples after main interval
    In.Src( 1 ).fdOrder   = 1;          % finite-difference order 
    In.Src( 1 ).fdType    = 'backward'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 501;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection

% ERSSTv5 data (and various NOAA products), satellite era, Indo-Pacific SST 
% input, 4-year delay embeding window  
case 'ersstV5_satellite_IPSST_4yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV5';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197801' '202003' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 28 290 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -60  20 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 1;          % samples before main interval
    In.Src( 1 ).nXA       = 0;          % samples after main interval
    In.Src( 1 ).fdOrder   = 1;          % finite-difference order 
    In.Src( 1 ).fdType    = 'backward'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'l2';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;        % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% ERSSTv5 data (and various NOAA products), satellite era, global SST 
% input, 4-year delay embeding window  
case 'ersstV5_satellite_globalSST_4yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV5';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197801' '202003' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -89 89 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 1;          % samples before main interval
    In.Src( 1 ).nXA       = 0;          % samples after main interval
    In.Src( 1 ).fdOrder   = 1;          % finite-difference order 
    In.Src( 1 ).fdType    = 'backward'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;        % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% ERSSTv5 data (and various NOAA products), last 50 years, Global SST input, 
% 4-year delay embeding window  
case 'ersstV5_50yr_globalSST_4yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV5';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197001' '202003' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -89 89 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% ERSSTV5 data (and various NOAA products), last 50 years, Global SST input, 
% 5-year delay embeding window  
case 'ersstV5_50yr_globalSST_5yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV5';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197001' '202003' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -89 89 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 60;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 1.5;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% ERSSTv4 data (and various NOAA products), last 50 years, Global SST input, 
% 4-year delay embeding window, cone kernel  
case 'ersstV4_50yr_globalSST_4yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV4';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197001' '202002' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -89 89 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% ERSSTV4 data (and various NOAA products), last 50 years, Indo-Pacific SST 
% input, 4-year delay embeding window, cone kernel  
case 'ersstV4_50yr_IPSST_4yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV4';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197001' '202002' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 28 290 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -60  20 ]; % latitude limits


    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 5.0E-4;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection







% ERSSTV4 data (and various NOAA products), satellite era, Global SST input, 
% 4-year delay embeding window  
case 'ersstV4_satellite_globalSST_4yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV4';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197801' '202002' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -89 89 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 3.0E-4;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% ERSSTV4 data (and various NOAA products), satellite era, Global SST input, 
% 4-year delay embeding window  
case 'ersstV4_satellite_globalSST_4yrEmb_l2Kernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV4';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197801' '202002' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -89 89 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'l2';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 3.0E-4;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% ERSSTV4 data (and various NOAA products), satellite era, sub-global SST 
% input, 4-year delay embeding window  
case 'ersstV4_satellite_subglobalSST_4yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV4';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197801' '202002' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -67 67 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 3.0E-4;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection



% ERSSTV4 data (and various NOAA products), satellite era, Indo-Pacific SST 
% input, 4-year delay embeding window, cone kernel  
case 'ersstV4_satellite_IPSST_4yrEmb_coneKernel'
    
    % Dataset specification 
    In.Res( 1 ).experiment = 'ersstV4';
    
    % Time specification 
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '197801' '202002' }; % time limit  
    In.Res( 1 ).tClim = { '198101' '201012' }; % climatology time limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 28 290 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -60  20 ]; % latitude limits


    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 451;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 3.0E-4;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman );        % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection





% CCSM4 pre-industrial control, 200-year period, Indo-Pacific SST input, 4-year
% delay embeding window  
case 'ccsm4Ctrl_200yr_IPSST_4yrEmb_coneKernel'
   
    % Dataset specification  
    In.Res( 1 ).experiment = 'ccsm4Ctrl'; 

    % Time specification
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '000101' '019912' }; % time limit  
    In.Res( 1 ).tClim = In.Res( 1 ).tLim;     % climatology limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 28 290 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -60  20 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 1;          % samples before main interval
    In.Src( 1 ).nXA       = 0;          % samples after main interval
    In.Src( 1 ).fdOrder   = 1;          % finite-difference order 
    In.Src( 1 ).fdType    = 'backward'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 501;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% CCSM4 pre-industrial control, 1300-year period, Indo-Pacific SST input, no
% delay embeding 
case 'ccsm4Ctrl_1300yr_IPSSTA_0yrEmb_l2Kernel'
   
    % Dataset specification  
    In.Res( 1 ).experiment = 'ccsm4Ctrl'; 

    % Time specification
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '000101' '130012' }; % time limit  
    In.Res( 1 ).tClim = In.Res( 1 ).tLim;     % climatology limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstma_000101-130012';     % physical field
    In.Src( 1 ).xLim  = [ 28 290 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -60  20 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 1;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 1;          % samples before main interval
    In.Src( 1 ).nXA       = 0;          % samples after main interval
    In.Src( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Src( 1 ).fdType    = 'backward'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'l2';       % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb';    % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 501;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    %In.koopmanOpType = 'diff';     % Koopman generator type
    %In.koopmanFDType  = 'central'; % finite-difference type
    %In.koopmanFDOrder = 4;         % finite-difference order
    %In.koopmanDt      = 1;         % sampling interval (in months)
    %In.koopmanAntisym = true;      % enforce antisymmetrization
    %In.koopmanEpsilon = 1E-3;      % regularization parameter
    %In.koopmanRegType = 'inv';     % regularization type
    %In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    %In.nPhiKoopman    = numel( In.idxPhiKoopman ); % Koopman eigenfunctions to compute
    %In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection

    % Koopman generator parameters; in-sample data
    %In.koopmanOpType = 'rkhs';     % Koopman generator type
    %In.koopmanFDType  = 'central'; % finite-difference type
    %In.koopmanFDOrder = 4;         % finite-difference order
    %In.koopmanDt      = 1;         % sampling interval (in months)
    %In.koopmanAntisym = true;      % enforce antisymmetrization
    %In.koopmanEpsilon = 7E-4;2.5E-3;      % regularization parameter
    %In.koopmanRegType = 'inv';     % regularization type
    %In.idxPhiKoopman  = 2 : 401;   % diffusion eigenfunctions used as basis
    %In.nPhiKoopman    = numel( In.idxPhiKoopman ); % Koopman eigenfunctions to compute
    %In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection




% CCSM4 pre-industrial control, 1300-year period, Indo-Pacific SST input, 4-year
% delay embeding window  
case 'ccsm4Ctrl_1300yr_IPSST_4yrEmb_coneKernel'
   
    % Dataset specification  
    In.Res( 1 ).experiment = 'ccsm4Ctrl'; 

    % Time specification
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '000101' '130012' }; % time limit  
    In.Res( 1 ).tClim = In.Res( 1 ).tLim;     % climatology limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 28 290 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -60  20 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 1;          % samples before main interval
    In.Src( 1 ).nXA       = 0;          % samples after main interval
    In.Src( 1 ).fdOrder   = 1;          % finite-difference order 
    In.Src( 1 ).fdType    = 'backward'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 501;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection

    % Koopman generator parameters; in-sample data
    %In.koopmanOpType = 'rkhs';     % Koopman generator type
    %In.koopmanFDType  = 'central'; % finite-difference type
    %In.koopmanFDOrder = 4;         % finite-difference order
    %In.koopmanDt      = 1;         % sampling interval (in months)
    %In.koopmanAntisym = true;      % enforce antisymmetrization
    %In.koopmanEpsilon = 7E-4;2.5E-3;      % regularization parameter
    %In.koopmanRegType = 'inv';     % regularization type
    %In.idxPhiKoopman  = 2 : 401;   % diffusion eigenfunctions used as basis
    %In.nPhiKoopman    = numel( In.idxPhiKoopman ); % Koopman eigenfunctions to compute
    %In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection

% CCSM4 pre-industrial control, 1300-year period, global SST input, 4-year
% delay embeding window  
case 'ccsm4Ctrl_1300yr_globalSST_4yrEmb_coneKernel'
   
    % Dataset specification  
    In.Res( 1 ).experiment = 'ccsm4Ctrl'; 

    % Time specification
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '000101' '130012' }; % time limit  
    In.Res( 1 ).tClim = In.Res( 1 ).tLim;     % climatology limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -89 89 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 1;          % samples before main interval
    In.Src( 1 ).nXA       = 0;          % samples after main interval
    In.Src( 1 ).fdOrder   = 1;          % finite-difference order 
    In.Src( 1 ).fdType    = 'backward'; % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 501;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 7E-4;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 401;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% CCSM4 pre-industrial control, 1300-year period, global SST input, 10-year
% delay embeding window  
case 'ccsm4Ctrl_1300yr_globalSST_10yrEmb_coneKernel'
   
    % Dataset specification  
    In.Res( 1 ).experiment = 'ccsm4Ctrl'; 

    % Time specification
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '000101' '130012' }; % time limit  
    In.Res( 1 ).tClim = In.Res( 1 ).tLim;     % climatology limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -89 89 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 120;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 501;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 5E-4;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 501;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection


% CCSM4 pre-industrial control, 1300-year period, global SST input, 20-year
% delay embeding window  
case 'ccsm4Ctrl_1300yr_globalSST_20yrEmb_coneKernel'
   
    % Dataset specification  
    In.Res( 1 ).experiment = 'ccsm4Ctrl'; 

    % Time specification
    In.tFormat        = 'yyyymm';              % time format
    In.Res( 1 ).tLim  = { '000101' '130012' }; % time limit  
    In.Res( 1 ).tClim = In.Res( 1 ).tLim;     % climatology limits 

    trendStr = ''; % string identifier for detrening of target data

    % Source data specification 
    In.Src( 1 ).field = 'sstw';      % physical field
    In.Src( 1 ).xLim  = [ 0 359 ];  % longitude limits
    In.Src( 1 ).yLim  = [ -89 89 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 240;     % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0
    In.lDist      = 'cone';     % local distance
    In.tol        = 0;          % 0 distance threshold (for cone kernel)
    In.zeta       = 0.995;      % cone kernel parameter 
    In.coneAlpha  = 0;          % velocity exponent in cone kernel
    In.nNS        = In.nN;      % nearest neighbors for symmetric distance
    In.diffOpType = 'gl_mb_bs'; % diffusion operator type
    In.epsilon    = 2;          % kernel bandwidth parameter 
    In.epsilonB   = 2;          % kernel bandwidth base
    In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
    In.nEpsilon   = 200;        % number of exponents for bandwidth tuning
    In.alpha      = 0.5;        % diffusion maps normalization 
    In.nPhi       = 501;        % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = 1 : 1;      % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;      % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;      % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 5E-4;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 501;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % Koopman eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % Koopman eigenfunctions for projection





otherwise
        error( 'Invalid experiment' )
end

%% PREPARE TARGET COMPONENTS (COMMON TO ALL MODELS)
%
% climStr is a string identifier for the climatology period relative to which
% anomalies are computed. 
%
% nETrg is the delay-embedding window for the target data

climStr = [ '_' In.Res( 1 ).tClim{ 1 } '-' In.Res( 1 ).tClim{ 2 } ];
nETrg   = 1; 

% Nino 3.4 index
In.Trg( 1 ).field = [ 'sstmawav' climStr ]; % physical field
In.Trg( 1 ).xLim  = [ 190 240 ];            % longitude limits
In.Trg( 1 ).yLim  = [ -5 5 ];               % latitude limits

% Nino 4 index
In.Trg( 2 ).field = [ 'sstmawav' climStr ]; % physical field
In.Trg( 2 ).xLim  = [ 160 210 ];            % longitude limits
In.Trg( 2 ).yLim  = [ -5 5 ];               % latitude limits

% Nino 3 index
In.Trg( 3 ).field = [ 'sstmawav' climStr ]; % physical field
In.Trg( 3 ).xLim  = [ 210 270 ];            % longitude limits
In.Trg( 3 ).yLim  = [ -5 5 ];               % latitude limits

% Nino 1+2 index
In.Trg( 4 ).field = [ 'sstmawav' climStr ]; % physical field
In.Trg( 4 ).xLim  = [ 270 280 ];            % longitude limits
In.Trg( 4 ).yLim  = [ -10 0 ];              % latitude limits

% Global SST anomalies
In.Trg( 5 ).field = [ 'sstma' trendStr climStr ]; % physical field
In.Trg( 5 ).xLim  = [ 0 359 ];                    % longitude limits
In.Trg( 5 ).yLim  = [ -89 89 ];                   % latitude limits

% Global SSH anomalies
In.Trg( 6 ).field = [ 'sshma' trendStr climStr ]; % physical field
In.Trg( 6 ).xLim  = [ 0 359 ];                    % longitude limits
In.Trg( 6 ).yLim  = [ -89 89 ] ;                  % latitude limits

% Global SAT anomalies
In.Trg( 7 ).field = [ 'airma' trendStr climStr ]; % physical field
In.Trg( 7 ).xLim  = [ 0 359 ];                    % longitude limits
In.Trg( 7 ).yLim  = [ -89 89 ];                   % latitude limits
        
% Global precipitation anomalies
In.Trg( 8 ).field = [ 'pratema' trendStr climStr ]; % physical field
In.Trg( 8 ).xLim  = [ 0 359 ];                      % longitude limits
In.Trg( 8 ).yLim  = [ -89 89 ];                     % latitude limits

% Global surface zonal wind anomalies 
In.Trg( 9 ).field = [ 'uwndma' trendStr climStr ]; % physical field
In.Trg( 9 ).xLim  = [ 0 359 ];                     % longitude limits
In.Trg( 9 ).yLim  = [ -89 89 ];                    % latitude limits

% Global surface meridional wind anomalies
In.Trg( 10 ).field = [ 'vwndma' trendStr climStr ]; % physical field
In.Trg( 10 ).xLim  = [ 0 359 ];                     % longitude limits
In.Trg( 10 ).yLim  = [ -89 89 ];                    % latitude limits
    
% Abbreviated target component names
In.targetComponentName   = [ 'nino_sst_ssh_air_prec_uv' ];
In.targetRealizationName = '_';

% Prepare dalay-embedding parameters for target data
for iCT = 1 : numel( In.Trg )
        
    In.Trg( iCT ).idxE      = 1 : nETrg;  % delay embedding indices 
    In.Trg( iCT ).nXB       = 1;          % before main interval
    In.Trg( iCT ).nXA       = 0;          % samples after main interval
    In.Trg( iCT ).fdOrder   = 0;          % finite-difference order 
    In.Trg( iCT ).fdType    = 'backward'; % finite-difference type
    In.Trg( iCT ).embFormat = 'overlap';  % storage format
end


%% CHECK IF WE ARE DOING OUT-OF-SAMPLE EXTENSION
ifOse = exist( 'Out', 'var' );

%% SERIAL DATE NUMBERS FOR IN-SAMPLE DATA
% Loop over the in-sample realizations
for iR = 1 : numel( In.Res )
    limNum = datenum( In.Res( iR ).tLim, In.tFormat );
    nS = months( limNum( 1 ), limNum( 2 ) ) + 1; 
    In.Res( iR ).tNum = datemnth( limNum( 1 ), 0 : nS - 1 ); 
end

%% SERIAL DATE NUMBERS FOR OUT-OF-SAMPLE DATA
if ifOse
    % Loop over the out-of-sample realizations
    for iR = 1 : numel( Out.Res )
        limNum = datenum( Out.Res( iR ).tLim, Out.tFormat );
        nS = months( limNum( 1 ), limNum( 2 ) ) + 1; 
        Out.Res( iR ).tNum = datemnth( limNum( 1 ), 0 : nS - 1 ); 
    end
end

%% CONSTRUCT NLSA MODEL
if ifOse
    args = { In Out };
else
    args = { In };
end
[ model, In, Out ] = climateNLSAModel( args{ : } );
