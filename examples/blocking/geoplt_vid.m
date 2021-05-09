rec_list = {[5], [6]};
batch_list = [96, 48]; % also 48, 36??

startind = 1460;
timesteps = 1600;

name_pre = "/kontiki6/cnv5172/NLSA/examples/blocking/data/nlsa/processed_data_den/z500w_x0-360_y30-90_blocking_20090101-20150101_idxE1-+1-20_idxT22-8766_central_fdOrd4/z500w_x0-360_y30-90_blocking_20090101-20150101_idxE1-+1-20_idxT22-8766_central_fdOrd4/l2_nN3000/d5_eps1_b2_lLim-40-40_nL200_kNN300_idxE1_idxT1-8745/l2_pwr_p0.2_nN3000/nNS3000/alpha0.50_eps2_b2_lLim-40-40_nL200_bs_nPhi32/z500w_x0-360_y30-90_blocking_20090101-20150101_1_idxE1-+1-20_idxT22-8766/";
% unweight data
%wgts;
unw = (reshape(w, 240, 41).^-1);
unw(:,39) = unw(:,38);
unw(:,40) = unw(:,38);
unw(:,41) = unw(:,38);
unw = transpose(unw);

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


newxLim = [ 0 359 ];
newyLim = [ 30 89 ];

for rrr = 1:length(rec_list)
    
    try
        rec_list(rrr);
        [ model, In ] = fastchange_phi(rec_list(rrr), batch_list(1));
        newx = getReconstructedData(model);
        
    catch
        [ model, In ] = fastchange_phi(rec_list(rrr), batch_list(2));
        newx = getReconstructedData(model);
        
    end

    
    plot_arr = reshape(newx, 41, [], 240);
   
    % get dates
    sz = size(newx);
    hhh = 0:(sz(2)-1);
    hrs = hours(hhh*6);
    
    dts = datetime(2009,01,01) + hrs;

    sn = append("figs/reconstruct_vids/recphi_", string(rec_list(rrr)),".avi")
    writerObj = VideoWriter(sn); %// initialize the VideoWriter object
    writerObj.Quality = 100;
    writerObj.FrameRate = 15;
    open(writerObj);

    lim_pos = max(abs(plot_arr), [], "all");
    for t = 1:timesteps
        toplot = unw.*squeeze(plot_arr(:,startind + t,:));
        if t == 1
            hfig = figure('visible','off');
            load coastlines
            axesm('pcarree', "Origin", [180], "MapLatLimit", [30 86], "MapLonLimit", [0 355])
            caxis manual
            colormap jet
            caxis([-1*lim_pos lim_pos]);
            contourcbar;
            
            contourfm(lat,lon,toplot);
            geoshow(coastlat,coastlon,'Color','k');
            title(append(string(dts(t + startind))));
               
            tightmap;

            fr = getframe(hfig);
            writeVideo(writerObj,fr)
        else
            newfig = figure('visible','off');
               load coastlines
               axesm('pcarree', "Origin", [180], "MapLatLimit", [30 86], "MapLonLimit", [0 355])
               caxis manual
               colormap jet
               caxis([-1*lim_pos lim_pos]);
               contourcbar;

               contourfm(lat,lon,toplot);
               geoshow(coastlat,coastlon,'Color','k');
               title(append(string(dts(t + startind))));
               %set(newfig, 'clim', origlim);
               tightmap;
               
               fr = getframe(newfig);
               writeVideo(writerObj,fr)
        end
    end 
    close(writerObj); 
end