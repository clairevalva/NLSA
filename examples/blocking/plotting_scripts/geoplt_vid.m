rrr = 28;

makegrid; % will just want lon from this but that is ok
wgts;

startind = 1460;
%timesteps = 20;
timesteps = 3000;

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
lat = ( 0 : nY - 1 ) * dLat;
lat = lat + 30
newxLim = [ 0 359 ];
newyLim = [ 30 89 ];

for lll = 1:1
    
    %get_model_changez;
    arr = real(reshape(zreconstruct, 41, [], 240));
    named = "z";
    newx = zreconstruct;
    
    plot_arr = arr;%reshape(newx, 41, [], 240);
   
    % get dates
    sz = size(newx);
    hhh = 0:(sz(2)-1);
    hrs = hours(hhh*6);
    
    dts = datetime(2009,01,01) + hrs;

    sn = append("figs/reconstruct_vids/recphi_nowgt_", string(rec_list(rrr)),".avi")
    writerObj = VideoWriter(sn); %// initialize the VideoWriter object
    writerObj.Quality = 100;
    %writerObj.FrameRate = 15;
    open(writerObj);

    lim_pos = max(abs(plot_arr), [], "all");
    for t = 1:timesteps
        toplot = squeeze(plot_arr(:,startind + t,:));%unw.*squeeze(plot_arr(:,startind + t,:));
        if t == 1
            hfig = figure('visible','off');
            load coastlines
            axesm('pcarree', "Origin", [180], "MapLatLimit", [30 86], "MapLonLimit", [0 355])
            caxis manual
            colormap jet
            caxis([-1*lim_pos lim_pos]);
            contourcbar;
            
            contourfm(lat,lon, toplot);
            geoshow(coastlat,coastlon,'Color','k');
            title(append(string(dts(t + startind))));
               
            %tightmap;

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

               contourfm(lat,lon, toplot);
               geoshow(coastlat,coastlon,'Color','k');
               title(append(string(dts(t + startind))));
               %set(newfig, 'clim', origlim);
               %tightmap;
               
               fr = getframe(newfig);
               writeVideo(writerObj,fr)
        end
    end 
    close(writerObj); 
end