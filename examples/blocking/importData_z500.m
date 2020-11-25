function Data = importData_z500( DataSpecs )
% IMPORTDATA_Z500 Read Z500 netCDF files, and output in format appropriate for 
% NLSA code.
% 
% DataSpecs is a data structure containing the specifications of the data to
% be read. 
%
% Data is a data structure containing the data read and associated attributes.
%
% DataSpecs has the following fields:
%
% In.dir:             Input directory name
% In.file:            Input filename base
% In.var:             Variable to be read
% Out.dir:            Output directory name
% Out.fld:            Output label 
% Time.tFormat:       Format of serial date numbers (e.g, 'yyyymm')
% Time.tLim:          Cell array of strings with time limits 
% Domain.xLim:        Longitude limits
% Domain.yLim:        Latitude limits
% Opts.ifWeight:      Perform area weighting if true 
% Opts.ifOutputData:  Only data attributes are returned if set to false
% Opts.ifWrite:       Write data to disk
%
% Modified 2020/11/24


%% UNPACK INPUT DATA STRUCTURE FOR CONVENIENCE
In     = DataSpecs.In;
Out    = DataSpecs.Out; 
Time   = DataSpecs.Time;
Domain = DataSpecs.Domain;
Opts   = DataSpecs.Opts;


%% READ DATA
% Variable name
fldStr = Out.fld; 

% Append 'w' if performing area weighting
if Opts.ifWeight
    fldStr = [ fldStr 'w' ];
end

% Output directory
dataDir = fullfile( Out.dir, ...
                    fldStr, ...
                    [ sprintf( 'x%i-%i',  Domain.xLim ) ...
                      sprintf( '_y%i-%i', Domain.yLim ) ...
                      '_' Time.tLim{ 1 } '-' Time.tLim{ 2 } ] );
if Opts.ifWrite && ~isdir( dataDir )
    mkdir( dataDir )
end

% Determine available files and number of monthly samples in each file
files = dir( fullfile( In.dir, [ '*' In.file '*.nc' ] ) );
nFile = numel( files );
nTFiles = zeros( 1, nFile );
for iFile = 1 : nFile

    % Open netCDF file, find number of samples
    ncId   = netcdf.open( fullfile( In.dir, files( iFile ).name ) );
    idTime = netcdf.inqDimID( ncId, 'time' );
    [ ~, nTFiles( iFile ) ] = netcdf.inqDim( ncId, idTime );
   
    % Close currently open file
    netcdf.close( ncId );
end


% Retrieve variable ID, lon/lat dimension from first netCDF file
ncId  = netcdf.open( fullfile( In.dir, files( 1 ).name ) );
idFld = netcdf.inqVarID( ncId, In.var );
idLon = netcdf.inqDimID( ncId, 'longitude' );
idLat = netcdf.inqDimID( ncId, 'latitude' );
[ ~, nX ] = netcdf.inqDim( ncId, idLon ); 
[ ~, nY ] = netcdf.inqDim( ncId, idLat ); 
netcdf.close( ncId );
 
% Create longitude-latitude grid, assumping 1.5 degree resolution
dLon = 1.5; 
dLat = 1.5;
lon = ( 0 : nX - 1 ) * dLon;
lon = lon( : ); % make into column vector 
lat = ( 0 : nY - 1 ) * dLat;
lat = lat( : ) - 90;
[ X, Y ] = ndgrid( lon, lat );

% Create region mask 
ifXY = X >= Domain.xLim( 1 ) & X <= Domain.xLim( 2 ) ...
     & Y >= Domain.yLim( 1 ) & Y <= Domain.yLim( 2 );
iXY = find( ifXY( : ) );
nXY = length( iXY );

% Determine serial date numbers
limNum = datenum( Time.tLim, Time.tFormat );
tNum   = limNum( 1 ) : limNum( 2 );
nT     = numel( tNum ); % number of days

% Initialize data array
fld = zeros( nXY, 4, nT );

iT = 1; % day counter          
ifNewfile = true; 

while iT <= nT

    ttt = datetime(datestr(tNum( iT )));

    %y = year( tNum( iT ) ); % orginally all like this, don't know why annoying
    y = year( ttt);
    m = month( ttt);
    d = day(ttt);

    if ifNewfile
        file = fullfile( In.dir, sprintf( '%i_%s.nc', y, In.file ) );  
        disp( sprintf( 'Opening file %s...', file ) )
        nCId = netcdf.open( file );
        fldFile = netcdf.getVar( ncId, idFld );
    end

    fldT = reshape( fldFile( m, d, :, :, : ), [ 4, nX * nY ] ); 
    fld( :, :, iT ) = fldT( :, iXY )';

    iT = iT + 1;
    
    if iT <= nT
        ifNewfile = year( ttt ) ~= y;
    end
end

fld = reshape( fld, [ nXY, 4 * nT ] );


% If requested, weigh the data by the (normalized) grid cell surface areas. 
% Surface area calculation is approximate as it treats Earth as spherical
if Opts.ifWeight

    % Convert to radians and augment grid periodically 
    diffLon = [ lon( 1 ) - dLon; lon; lon( end ) + dLon ] * pi / 180; 
    diffLat = [ lat( 1 ) - dLat; lat; lat( end ) + dLat ] * pi / 180;

    % Compute grid coordinate differences
    diffLon = ( diffLon( 1 : end - 1 ) + diffLon( 2 : end ) ) / 2;
    diffLon = abs( diffLon( 2 : end ) - diffLon( 1 : end - 1 ) );
    diffLat = ( diffLat( 1 : end - 1 ) + diffLat( 2 :end ) ) / 2;
    diffLat = diffLat( 2 : end ) - diffLat( 1 : end - 1 );
    diffLat = abs( diffLat .* cos( lat * pi / 180 ) );

    % Compute surface area weights
    w = diffLon .* diffLat';
    w = w( ifXY );
    w = sqrt( w / sum( w ) * nXY );
      
    % Weigh the data
    fld = fld .* w;
end



% Output data dimension
nD = size( fld, 1 );


%% RETURN AND WRITE DATA
% Grid information
gridVarList = { 'lat', 'lon', 'ifXY', 'fldStr', 'nD' };
if Opts.ifWrite
    gridFile = fullfile( dataDir, 'dataGrid.mat' );
    save( gridFile, gridVarList{ : }, '-v7.3' )  
end

% Output data and attributes
x = fld; % for compatibility with NLSA code
varList = { 'x' };
if Opts.ifWrite
    fldFile = fullfile( dataDir, 'dataX.mat' );
    save( fldFile, varList{ : },  '-v7.3' )  
end

% If needed, assemble data and attributes into data structure and return
if nargout > 0
    varList = [ varList gridVarList ];
    if ~Opts.ifOutputData
        % Exclude data from output 
        varList = varList( 2 : end );
    end
    nVar = numel( varList );
    vars = cell( 1, nVar );
    for iVar = 1 : nVar
       vars{ iVar } = eval( varList{ iVar } );
    end
    Data = cell2struct( vars, varList, 2 );
end


