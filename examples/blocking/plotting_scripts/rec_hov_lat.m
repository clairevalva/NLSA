function f = rec_hov_lat(wantrec, latind, totall)

    % want rec is the reconstruction I want to look at
    batch_list = [96, 48]; % also 48, 36??
    save_pre = "/kontiki6/cnv5172/NLSA/examples/blocking/figs/reconstructions/rec_hovs/hov_rec_phi_"
    
    % get grid and weights
    makegrid; % will just want lon from this but that is ok
    wgts;

    rrr = wantrec;

    savename = save_pre + string(wantrec) + "_lat_" + string(30 + 1.5*latind) + ".png"
    % pull the reconstructed data
    get_model_changephi;
    plot_arr = reshape(newx, 41, [], 240);

    plot_arr = squeeze(plot_arr(latind, :, :))

    

    startdate = datetime(2009,01, 01); 

    lentime = size(plot_arr,1);
    hhh = 0:(lentime-1);
    hrs = hours(hhh*6);
    dts = startdate + hrs;

    unw = (reshape(w, 240, 41).^-1);
    
    lim_pos = max(abs(plot_arr), [], "all");

    formatted = plot_arr.*unw(:,latind)

    figure('position', [1, 1, 500, 1000]);
    caxis manual
    colormap jet
    caxis([-1*lim_pos lim_pos]);
    contourf(lon, datenum(dts(1:totall)), formatted(1:totall,:), 30,'LineColor', 'none')
    h = colorbar;
    xlabel("deg E")
    ylabel("date")
    ylabel(h, 'z500 comp (m/s)');
    
    print('-dpng','-r500',savename)
    close

end