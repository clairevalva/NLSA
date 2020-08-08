function [ fPred, c ] = unitaryForecast( f, phi, mu, omega, phiO, t )
% UNITARYFORECAST Compute the evolution of an observable under unitary 
% dynamics in a basis of generator eigenfunctions.
%
% Input arguments:
%
% f:      Training data array of size [ nD, nS ], where nD is the data space 
%         dimension and nSF the number of training samples.
%
% phi:    Basis function array of size [ nS, nL ], where nL is the number of 
%         eigenfunctions of the generator. 
%
% omega: [ nL ] sized vector containing the eigenfrequencies corresponding 
%        to phi.
%
% phiO:   Array of size [ nSO, nL ] containing the out-of-sample values of the
%         basis functions at forecast initialization. nSO is the number of 
%         test data. 
%
% t:     [ nT ] sized vector containing the forecast lead times.
%
% Output arguments:
%
% fPred:  Forecast data array of size [ nD, nT, nSO ]. f( :, iT, iSO ) is the 
%         nD-dimensional forecast vector for lead time iT and the iSO-th 
%         initial condition.
%
% cT:     Array of size [ nD, nT, nL ] containing the expansion coeffcients of
%         the forward-evolved observable the phi basis. 
%
% Modified 2020/08/07

% Get array dimensions
[ nD, nS ] = size( f );
[ ~, nL ] = size( phi ); 
nSO = size( phiO, 1 );
nT = numel( t );

% Compute expansion coefficients of f with respect to the phi basis
c = f * ( conj( phi ) .* mu ); % size nD nL
c = reshape( c, [ nD 1 nL ] ); 

% Compute the forward evolution of the expansion coefficients 
omega = reshape( omega, [ 1 1 nL ] );
t = reshape( t, [ 1 nT ] ); 
cT = c .* exp( i * omega .* t );
cT = reshape( c, [ nD nT nL ] ); 

% Evaluate forecast using out-of-sample values of the eigenfunctions
fPred = cT * phiO.' ;
fPred = reshape( fPred, [ nD nT nSO ] );

% Reshape coefficient array
if nargout > 1
    cT = reshape( cT, [ nD nT nL ] );
end
