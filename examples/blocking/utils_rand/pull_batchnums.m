function Bs = pull_batchnums(nbatch, tindstart, tindend, lonmin, lonmax)
    s1 = lonmax - lonmin + 1;
    s2 = tindend - tindstart + 1;
    X = zeros([s1, s2]);
    for m = 1:s1
        for n = 1:s2
            X(m,n) = (m-1)*nbatch + n;
        end

    end
    Bs = X;
end