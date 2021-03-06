function [ model, In, Out ] = blocking_vsaModel( experiment )
% BLOCKING_VSAMODEL Construct VSA model for analysis of Z500 data
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
% Modified 2021/03/19

if nargin == 0
    experiment = 'z500_20101230-20110131_emb5_coneKernel';
end

switch experiment

case 'z500_20090101-20120230_emb20_l2Kernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20090101' '20120230' }; % time limit  
    
    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'z500w';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'z500w';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 24; % partition batches
    In.Res( 1 ).nBRec = 24; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 3000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 8;          % number of batches for query partition 
    In.nBT        = 8;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 64;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = {[ 2:64] };    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 64;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2:12];

case 'lwa_20090101-20120230_emb20_l2Kernel_no'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20090101' '20120230' }; % time limit  

    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'lwaw';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'lwaw';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 48; % partition batches
    In.Res( 1 ).nBRec = 48; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 3000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 8;          % number of batches for query partition 
    In.nBT        = 8;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 32;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = {[ 2:12] };    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 32;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2:12];

case 'z500_20090101-20120230_emb20_l2Kernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20090101' '20120230' }; % time limit  
    
    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'z500w';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'z500w';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 48; % partition batches
    In.Res( 1 ).nBRec = 48; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 3000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 8;          % number of batches for query partition 
    In.nBT        = 8;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 32;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = {[ 2:12] };    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 32;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2:12];

case 'z500_20090101-20150101_emb20_l2Kernel'
    % BIG USING

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20090101' '20150101' }; % time limit  

    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'z500w';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'z500w';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 96; % partition batches
    In.Res( 1 ).nBRec = 36; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 3000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 32;          % number of batches for query partition 
    In.nBT        = 32;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 1000;%32;         % diffusion eigenfunctions to compute
                                %1000 eigenfunctions took approx 70 hours
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = {[18:32]};    % eigenfunctions for reconstruction
    % done [ 2:12], sessions are: [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16]
    % [18], [17], [19], [20]. [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31], [32]
    %[33], [34], 
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 1000;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = 300 %numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = {[8]}; % done [ 4:12]

case 'z500_20120101-20130230_emb20_l2Kernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20120101' '20130230' }; % time limit  
    
    
    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'z500w';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'z500w';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 16; % partition batches
    In.Res( 1 ).nBRec = 16; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 4000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 4;          % number of batches for query partition 
    In.nBT        = 4;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 16;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = {[5]  };%[4]};%{[3:12]}%{[2] [3] [4] [5] [6] [7] [8] [9]} %[ 1:12];    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 16;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2 3 ];

case 'lwa_20120101-20130229_emb20_l2Kernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                
    
    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20120101' '20130229' }; % time limit  
    
    
    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'lwaw';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 45 45 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'lwaw';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 45 45 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 16; % partition batches
    In.Res( 1 ).nBRec = 16; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 4000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 4;          % number of batches for query partition 
    In.nBT        = 4;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 16;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = {[5]  };%[4]};%{[3:12]}%{[2] [3] [4] [5] [6] [7] [8] [9]} %[ 1:12];    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 16;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2 3 ];
case 'lwa_20120101-20130230_emb20_l2Kernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20120101' '20130230' }; % time limit  
    
    
    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'lwaw';   % physical field (area-weighted lwa)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'lwaw';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 16; % partition batches
    In.Res( 1 ).nBRec = 16; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 4000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 4;          % number of batches for query partition 
    In.nBT        = 4;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 16;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = [ 2:12];    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 16;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2 3 ];
case 'z500_20120101-20130230_emb50_l2Kernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20120101' '20130230' }; % time limit  
    
    
    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'z500w';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'z500w';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 50;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 50;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 16; % partition batches
    In.Res( 1 ).nBRec = 16; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 4000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 3;          % number of batches for query partition 
    In.nBT        = 3;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 16;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = [ 1:12];    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 16;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2 3 ];

case 'z500_20120101-20130230_emb20_l2Kernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20120101' '20130230' }; % time limit  
    
    
    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'z500w';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'z500w';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 16; % partition batches
    In.Res( 1 ).nBRec = 16; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 4000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 4;          % number of batches for query partition 
    In.nBT        = 4;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 16;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = [ 1:12];    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 16;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2 3 ];
case 'lwa_20120101-20130230_emb20_l2Kernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20120101' '20130230' }; % time limit  
    
    
    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'lwaw';   % physical field (area-weighted lwa)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'lwaw';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 16; % partition batches
    In.Res( 1 ).nBRec = 16; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 4000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 4;          % number of batches for query partition 
    In.nBT        = 4;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 16;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = [ 2 3 ];    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 16;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2 3 ];
case 'lwa_20120101-20130230_emb20_l2Kernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20120101' '20130230' }; % time limit  
    
    
    % Number of spatial gridpoints
    In.Res( 1 ).nG = 240;

    % z500 field (source)
    In.Src( 1 ).field      = 'lwaw';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'lwaw';   % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 20;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 20;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 16; % partition batches
    In.Res( 1 ).nBRec = 16; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 4000;          % nearest neighbors; defaults to max. value if 0
    In.nBQ        = 3;          % number of batches for query partition 
    In.nBT        = 3;          % number of batches for test partition 
    In.lDist      = 'l2';       % local distance
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
    In.nPhi       = 16;         % diffusion eigenfunctions to compute
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = [ 1:12];    % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % NLSA parameters, kernel density estimation 
    In.denType     = 'vb';          % density estimation type
    In.denND       = 5;             % manifold dimension 
    In.denLDist    = 'l2';          % local distance function 
    In.denBeta     = -1 / In.denND; % density exponent 
    In.denNN       = 300;           % nearest neighbors 
    In.denZeta     = 0;             % cone kernel parameter 
    In.denConeAlpha= 0;             % cone kernel velocity exponent 
    In.denEpsilon  = 1;             % kernel bandwidth
    In.denEpsilonB = 2;             % kernel bandwidth base 
    In.denEpsilonE = [ -40 40 ];    % kernel bandwidth exponents 
    In.denNEpsilon = 200;        % number of exponents for bandwidth tuning

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 16;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = [ 2 3 ];
otherwise

    error( 'Invalid experiment' )
end


%% PREPARE TARGET COMPONENTS (COMMON TO ALL MODELS)
if ~isfield( In, 'Trg' )
    In.Trg = In.Src;
end

%% CHECK IF WE ARE DOING OUT-OF-SAMPLE EXTENSION
ifOse = exist( 'Out', 'var' );

%% SERIAL DATE NUMBERS FOR IN-SAMPLE DATA
% Loop over the in-sample realizations
for iR = 1 : numel( In.Res )
    limNum = datenum( In.Res( iR ).tLim, In.tFormat );
    In.Res( iR ).tNum = limNum( 1 ) : 1 / 4 : (limNum( 2 ) + 3/4);
end

%% SERIAL DATE NUMBERS FOR OUT-OF-SAMPLE DATA
if ifOse
    % Loop over the out-of-sample realizations
    for iR = 1 : numel( Out.Res )
        limNum = datenum( Out.Res( iR ).tLim, In.tFormat );
        Out.Res( iR ).tNum = limNum( 1 ) : 1 / 4 : (limNum( 2 ) + 3/4);
    end
end

%% CONSTRUCT NLSA MODEL
if ifOse
    args = { In Out };
else
    args = { In };
end
[ model, In, Out ] = climateVSAModel( args{ : } );
