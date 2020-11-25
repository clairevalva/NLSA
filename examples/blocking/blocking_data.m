function blocking_data( fld, tLim )
% BLOCKING_DATA Helper function to import datasets for NLSA/Koopman analysis of
% blocking.
%
% fld   - String identifier for variable to read. 
% tLim  - Cell array of strings for time limits of analysis period. 
%
% This function creates a data structure with input data specifications as 
% appropriate for the dataset and fld arguments. 
%
% The data is then retrieved and saved on disk using the importData function. 
%
% Modified 2020/10/29

% Directory for input data 
DataSpecs.In.dir = '/Users/clairev/Desktop/';
% DataSpecs.In.dir = '/Users/dg227/GoogleDrive/physics/climate/data'; 
DataSpecs.In.dir  = fullfile( DataSpecs.In.dir, 'GPH_tosend' );

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
    importData_z500( DataSpecs )

otherwise
    error( 'Invalid input variable' )
end


