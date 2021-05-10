% Create longitude-latitude grid, assumping 1.5 degree resolution
nX = 240;
nY = 41;

xLim = [ 0 360 ]; % longitude limits
yLim = [ 30 90 ];

dLon = 1.5; 
dLat = 1.5;
lon = ( 0 : nX - 1 ) * dLon;
lon = lon( : ); % make into column vector 
lat = ( 0 : nY - 1 ) * dLat;
lat = yLim(1) + lat( : );
[ X, Y ] = ndgrid( lon, lat );

% Create region mask 
ifXY = X >= xLim( 1 ) & X <= xLim( 2 ) ...
    & Y >= yLim( 1 ) & Y <= yLim( 2 );
iXY = find( ifXY( : ) );
nXY = length( iXY );

X = reshape(X, 1, []);
Y = reshape(Y,1,[]);