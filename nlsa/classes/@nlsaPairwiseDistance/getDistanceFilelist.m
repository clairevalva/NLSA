function file = getDistanceFilelist( obj, iR )
% GETDISTANCEFILELIST  Get distance filelist of an nlsaPairwiseDistance object
%
% Modified 2014/04/15

if nargin == 1
    iR = 1 : numel( obj.file );
end

for i = numel( iR ) : -1 : 1
    file( i ) = obj.file( iR( i ) );
end
