%recls = okinds(okinds <= 100);
recls  = [47    48    57    58    62    63    64    65    85    86    95    96   100 23 24 26 27 12 13];
% done 18, 19, 47, 48,  57    58    62    63
for k = 18: 19
    rr = recls(k)
    % build model
    [ model, In ] = fastchange_z([rr]);

    % do reconstruction
    disp( 'Reconstruction of target data from Koopman eigenfunctions... ' + string(rr)); 
    t = tic;
    computeKoopmanReconstruction( model, [1],[], [], [], 0  )
    toc( t )
end 