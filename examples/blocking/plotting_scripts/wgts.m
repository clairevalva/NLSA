% Create longitude-latitude grid, assumping 1.5 degree resolution
nX = 240;
nY = 121;

% Create longitude-latitude grid, assumping 1.5 degree resolution
dLon = 1.5; 
dLat = 1.5;
lon = ( 0 : nX - 1 ) * dLon;
lon = lon( : ); % make into column vector 
lat = ( 0 : nY - 1 ) * dLat;
lat = lat( : ) - 90;
[ X, Y ] = ndgrid( lon, lat );

% Create region mask 
ifXY = X >= 0 & X <= 360 ...
     & Y >= 30 & Y <= 90;
iXY = find( ifXY( : ) );
nXY = length( iXY );


% get weights for lat/lon
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
w; 