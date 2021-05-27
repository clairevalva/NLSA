% give X which has size [lonmax - lonmin + 1, tindend - tindstart + 1]

% load first one
zfirst = getKoopmanReconstructedData(model, X(1,1));
sizet = size(zfirst, 2);
sizelon = size(X, 1);
numtinds = size(X, 2);

% want sized like (41, [], 240)
zrecs = zeros(41, sizet*numtinds, sizelon);
zrecs(:, 1:sizet, 1) = zfirst;

% load and put the rest togethers
for l = 1:sizelon
    for t = 1:numtinds
        zget = getKoopmanReconstructedData(model, X(l,t));
        zrecs(:,(t - 1)*sizet + 1:t*sizet, l) = zget;
    end
end


