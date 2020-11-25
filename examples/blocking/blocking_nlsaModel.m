function [ model, In, Out ] = blocking_nlsaModel( experiment )
% BLOCKING_NLSAMODEL Construct NLSA model for analysis of Z500 data
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
% Modified 2020/11/24

if nargin == 0
    experiment = 'z500_20101230-20110131_emb5_coneKernel';
end

switch experiment

case 'z500_20101230-20111031_emb5_coneKernel'

    % Dataset specification  
    In.Res( 1 ).experiment = 'blocking';                

    % Time specification
    In.tFormat        = 'yyyymmdd';              % time format
    In.Res( 1 ).tLim  = { '20101230' '20111031' }; % time limit  

    % z500 field (source)
    In.Src( 1 ).field      = 'z500w';   % physical field (area-weighted z500)
    In.Src( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Src( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % z500 field (target)
    In.Trg( 1 ).field      = 'z500w';      % physical field
    In.Trg( 1 ).xLim       = [ 0 360 ]; % longitude limits
    In.Trg( 1 ).yLim       = [ 30 90 ]; % latitude limits

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Src( 1 ).idxE      = 1 : 5;      % delay-embedding indices 
    In.Src( 1 ).nXB       = 2;          % samples before main interval
    In.Src( 1 ).nXA       = 2;          % samples after main interval
    In.Src( 1 ).fdOrder   = 4;          % finite-difference order 
    In.Src( 1 ).fdType    = 'central';  % finite-difference type
    In.Src( 1 ).embFormat = 'overlap';  % storage format 

    % Delay-embedding/finite-difference parameters; in-sample data
    In.Trg( 1 ).idxE      = 1 : 5;     % delay-embedding indices 
    In.Trg( 1 ).nXB       = 0;          % samples before main interval
    In.Trg( 1 ).nXA       = 0;          % samples after main interval
    In.Trg( 1 ).fdOrder   = 0;          % finite-difference order 
    In.Trg( 1 ).fdType    = 'central';  % finite-difference type
    In.Trg( 1 ).embFormat = 'overlap';  % storage format 

    % Batches to partition the in-sample data
    In.Res( 1 ).nB    = 1; % partition batches, make higher for less RAM
    In.Res( 1 ).nBRec = 1; % batches for reconstructed data

    % NLSA parameters; in-sample data 
    In.nN         = 0;          % nearest neighbors; defaults to max. value if 0, want at least 10% of timesteps
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
    In.nPhi       = 11;         % diffusion eigenfunctions to compute, how many eigenfunctions
    In.nPhiPrj    = In.nPhi;    % eigenfunctions to project the data
    In.idxPhiRec  = { [ 2 3 ] ...
                      [ 4 5 ] };  % eigenfunctions for reconstruction
    In.idxPhiSVD  = 1 : 1;        % eigenfunctions for linear mapping
    In.idxVTRec   = 1 : 1;        % SVD termporal patterns for reconstruction

    % Koopman generator parameters; in-sample data
    In.koopmanOpType = 'diff';     % Koopman generator type
    In.koopmanFDType  = 'central'; % finite-difference type
    In.koopmanFDOrder = 4;         % finite-difference order
    In.koopmanDt      = 1;         % sampling interval (in months)
    In.koopmanAntisym = true;      % enforce antisymmetrization
    In.koopmanEpsilon = 1.0E-3;      % regularization parameter
    In.koopmanRegType = 'inv';     % regularization type
    In.idxPhiKoopman  = 1 : 11;   % diffusion eigenfunctions used as basis
    In.nPhiKoopman    = numel( In.idxPhiKoopman ); % eigenfunctions to compute
    In.nKoopmanPrj    = In.nPhiKoopman; % eigenfunctions to project the data 
    In.idxKoopmanRec  = { [ 2 3 ] [ 4 5 ] };

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
    In.Res( iR ).tNum = limNum( 1 ) : 1 / 4 : limNum( 2 );
end

%% SERIAL DATE NUMBERS FOR OUT-OF-SAMPLE DATA
if ifOse
    % Loop over the out-of-sample realizations
    for iR = 1 : numel( Out.Res )
        limNum = datenum( Out.Res( iR ).tLim, In.tFormat );
        Out.Res( iR ).tNum = limNum( 1 ) : 1 / 4 : limNum( 2 );
    end
end

%% CONSTRUCT NLSA MODEL
if ifOse
    args = { In Out };
else
    args = { In };
end
[ model, In, Out ] = climateNLSAModel( args{ : } );
