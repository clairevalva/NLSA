function blocking_vsa_data( fld, tLim )
% BLOCKING_VSA_DATA Helper function to import datasets for VSA/Koopman analysis 
% of blocking.
%
% fld   - String identifier for variable to read. 
% tLim  - Cell array of strings for time limits of analysis period. 
%
% This function creates a data structure with input data specifications as 
% appropriate for the dataset and fld arguments. 
%
% The data is then retrieved and saved on disk using the importData function. 
%
% Modified 2021/03/17 
DataSpecs.In.dir = '/kontiki6/cnv5172/NLSA/examples/blocking/';
DataSpecs.In.dir  = fullfile( DataSpecs.In.dir, 'z500_data' );

% Output directory
DataSpecs.Out.dir = fullfile( pwd, 'data/raw', 'blocking' );

% Time specification
DataSpecs.Time.tFormat = 'yyyymmdd';    
DataSpecs.Time.tLim    = tLim; 
    
% Spatial domain 
DataSpecs.Domain.xLim = [ 0 360 ]; % longitude limits
DataSpecs.Domain.yLim = [ 30 90 ]; % latitude limits

% Output variable name
DataSpecs.Out.fld = fld;

% Output options
DataSpecs.Opts.ifWrite  = true; % write data to disk
DataSpecs.Opts.ifWeight = true; % do area weighting


% Set variable/file names, read data 
switch fld
case 'z500'

    DataSpecs.In.file = 'Z500';
    DataSpecs.In.var  = fld;
    importData_vsa_z500( DataSpecs )

case 'lwa'
    % Directory for input data 
    DataSpecs.Domain.yLim = [ 30 90 ];
    DataSpecs.In.dir = '/kontiki6/cnv5172/NLSA/examples/blocking/';
    DataSpecs.In.dir  = fullfile( DataSpecs.In.dir, 'LWA_data' );
    DataSpecs.In.file = 'LWA2';
    DataSpecs.In.var  = "lwa";
    DataSpecs.Domain
    importData_vsa_LWA( DataSpecs )
    
otherwise
    error( 'Invalid input variable' )
end


