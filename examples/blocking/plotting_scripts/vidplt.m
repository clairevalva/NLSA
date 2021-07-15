% get reconstructions
X = pull_batchnums(18, 1, 1, 1, 240);
vidzs = [47    48    57    58    62    63];
savepre = "figs/reconstructions/rec_vids/shortt_z_real_"


% unweight data
wgts;
unw = (reshape(w, 240, 41).^-1);
unw(:,39) = unw(:,38);
unw(:,40) = unw(:,38);
unw(:,41) = unw(:,38);
unw = transpose(unw);

% Create longitude-latitude grid, assumping 1.5 degree resolution
makegrid;
nX = 240;
nY = 41;
lat = ( 0 : nY - 1 ) * dLat;
lat = lat + 30;
newxLim = [ 0 359 ];
newyLim = [ 30 89 ];

for zz = 2:size(vidzs,2)
    disp("vid plotting for eig = ")
    wantz = vidzs(zz)
    fastchange_z(wantz);
    X = pull_batchnums(18, 1, 1, 1, 240);
    pull_recs; % returns zrecs, also defs sizet
    zrecs = real(zrecs);

    % get dates 
    hhh = 0:(sizet-1);
    hrs = hours(hhh*6);
    dts = datetime(2009,01,01) + hrs;

    % initialize the VideoWriter object
    sn = savepre + string(wantz) + ".png";
    writerObj = VideoWriter(sn); 
    writerObj.Quality = 100;
    open(writerObj);

    lim_pos = max(abs(zrecs), [], "all");
    for t = 1:sizet
        hfig = figure('visible','off');
        load coastlines
        axesm('pcarree', "Origin", [180], "MapLatLimit", [30 86], "MapLonLimit", [0 355])
        caxis manual
        colormap jet
        caxis([-1*lim_pos lim_pos]);
        contourcbar;
        contourfm(lat,lon, squeeze(zrecs(:,t,:)));
        geoshow(coastlat,coastlon,'Color','k');
        title(string(dateshift(dts(t), "start", "day")))
        fr = getframe(hfig);
        writeVideo(writerObj,fr)
    end 
    close(writerObj); 
end

 

