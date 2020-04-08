function [ model, In, Out ] = noaaNLSAModel( experiment )
% NOAANLSAMODEL Construct NLSA model for NOAA 20th Century reanalysis (20CRv2)
%  data.
% 
%  experiment is a string identifier of the data analysis experiment.
%
%  In and Out are data structures containing the in-sample (training) and 
%  out-of-sample (verification) model parameters, respectively.
%
%  This function creates a data structure In and (optionally) a data structure
%  Out, which are then passed to the function climateNLSAModel_base to 
%  construct the model.
%
%  The following script is provided for data import: 
%
%      noaaData.m
%               
%  Longitude range is [ 0 359 ] at 1 degree increments
%  Latitude range is [ -89 89 ] at 1 degree increments
%  Date range is is January 1854 to June 2019  at 1 month increments
%
% Modified 2020/03/27
 
if nargin == 0
    experiment = 'enso_lifecycle';
end

switch experiment

    % ENSO LIFECYCLE BASED ON INDO-PACIFIC SST 
    case 'enso_lifecycle'

        % In-sample dataset parameters 
        % Source (covariate) data is area-weighted Indo-Pacific SST
        % Target (response) data is Nino 3.4 index
        In.tFormat             = 'yyyymm';              % time format
        In.freq                = 'monthly';             % sampling frequency
        In.Res( 1 ).tLim       = { '187001' '201906' }; % time limit  
        In.Res( 1 ).experiment = 'noaa';                % 20CRv2 dataset
        In.Src( 1 ).field      = 'sstw';      % physical field
        In.Src( 1 ).xLim       = [ 28 290 ];  % longitude limits
        In.Src( 1 ).yLim       = [ -60  20 ]; % latitude limits
        In.Trg( 1 ).field      = 'sstmawav_198101-201012';  % physical field
        In.Trg( 1 ).xLim       = [ 190 240 ];  % longitude limits
        In.Trg( 1 ).yLim       = [ -5 5 ];     % latitude limits

        % Delay-embedding/finite-difference parameters; in-sample data
        In.Src( 1 ).idxE      = 1 : 48;     % delay-embedding indices 
        In.Src( 1 ).nXB       = 1;          % samples before main interval
        In.Src( 1 ).nXA       = 0;          % samples after main interval
        In.Src( 1 ).fdOrder   = 1;          % finite-difference order 
        In.Src( 1 ).fdType    = 'backward'; % finite-difference type
        In.Src( 1 ).embFormat = 'overlap';  % storage format 
        In.Trg( 1 ).idxE      = 1 : 1;      % delay embedding indices 
        In.Trg( 1 ).nXB       = 1;          % before main interval
        In.Trg( 1 ).nXA       = 0;          % samples after main interval
        In.Trg( 1 ).fdOrder   = 1;          % finite-difference order 
        In.Trg( 1 ).fdType    = 'backward'; % finite-difference type
        In.Trg( 1 ).embFormat = 'overlap';  % storage format
        In.Res( 1 ).nB        = 1;          % partition batches
        In.Res( 1 ).nBRec     = 1;          % batches for reconstructed data

        % NLSA parameters; in-sample data 
        In.nN         = 0; % nearest neighbors; defaults to max. value if 0
        In.lDist      = 'cone'; % local distance
        In.tol        = 0;      % 0 distance threshold (for cone kernel)
        In.zeta       = 0.995;  % cone kernel parameter 
        In.coneAlpha  = 0;      % velocity exponent in cone kernel
        In.nNS        = In.nN;  % nearest neighbors for symmetric distance
        In.diffOpType = 'gl_mb_bs'; % diffusion operator type
        In.epsilon    = 2;          % kernel bandwidth parameter 
        In.epsilonB   = 2;          % kernel bandwidth base
        In.epsilonE   = [ -40 40 ]; % kernel bandwidth exponents 
        In.nEpsilon   = 200;      % number of exponents for bandwidth tuning
        In.alpha      = 0.5;      % diffusion maps normalization 
        In.nPhi       = 501;      % diffusion eigenfunctions to compute
        In.nPhiPrj    = In.nPhi;  % eigenfunctions to project the data
        In.idxPhiRec  = 1 : 1;    % eigenfunctions for reconstruction
        In.idxPhiSVD  = 1 : 1;    % eigenfunctions for linear mapping
        In.idxVTRec   = 1 : 1;    % SVD termporal patterns for reconstruction

    otherwise
        error( 'Invalid experiment' )
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

[ model, In, Out ] = climateNLSAModel_base( args{ : } );