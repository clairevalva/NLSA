function demoNLSA_data( experiment )
% DEMONLSA_DATA Helper function to generate datasets for NLSA demo for L63
% system.
%
% experiment - String identifier for data analysis experiment
%
% This function creates a parameter structure with input data specifications 
% as appropriate for the experiment. 
%
% The data is then generated and saved on disk using the l63Data function. 
%
% Modified 2020/06/06

%% SET EXPERIMENT-SPECIFIC PARAMETERS
switch experiment

% 6400 samples, sampling interval 0.01, no delay embedding 
case '6.4k_dt0.01_nEL0'

    DataSpecs.Time.dt     = 0.01;  % sampling interval
    DataSpecs.Time.nSSpin = 64000; % spinup samples
    DataSpecs.Time.nSProd = 6400;  % production samples
    DataSpecs.Time.nEL    = 0;     % embedding window length

% 64000 samples, sampling interval 0.01, no delay embedding 
case '64k_dt0.01_nEL0'

    DataSpecs.Time.dt     = 0.01;  % sampling interval
    DataSpecs.Time.nSSpin = 64000; % spinup samples
    DataSpecs.Time.nSProd = 64000; % production samples
    DataSpecs.Time.nEL    = 0;     % embedding window length

otherwise
    
    error( 'Invalid experiment' )

end


%% SET PARAMETERS COMMON TO ALL EXPERIMENTS

% Standard L63 parameters
DataSpecs.Pars.beta   = 8/3;         % L63 parameter beta
DataSpecs.Pars.rho    = 28;          % L63 parameter rho
DataSpecs.Pars.sigma  = 10;          % L63 parameter sigma

% Initial conditions and tolerance for ODE solver
DataSpecs.Ode.x0     = [ 0 1 1.05 ]; % initial conditions
DataSpecs.Ode.relTol = 1E-8;         % relative tolerance for ODE solver 

% Output options
DataSpecs.Opts.ifCenter = false;     % don't do data centering
DataSpecs.Opts.ifWrite  = true;       % write data to disk  

%% GENERATE DATA
l63Data( DataSpecs );


