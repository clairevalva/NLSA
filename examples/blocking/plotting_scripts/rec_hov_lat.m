function f = rec_hov_lat(wantrec, latind, totall)

    % want rec is the reconstruction I want to look at
    batch_list = [48, 96]; % also 48, 36??
    save_pre = "/scratch/cnv5172/NLSA/examples/blocking/figs/reconstructions/test2_hov_rec_phi_"
    
    % get grid and weights
    makegrid; % will just want lon from this but that is ok
    wgts;

    rrr = wantrec;

    savename = save_pre + string(wantrec) + "_lat_" + string(30 + 1.5*latind) + ".png";
    savename_spectra = "/scratch/cnv5172/NLSA/examples/blocking/figs/spectra/spectra_phi_" + string(wantrec) + "_lat_" + string(30 + 1.5*latind) + ".png";
    % pull the reconstructed data
    get_model_changephi;
    arr = reshape(newx, 41, 240, []);

    plot_arr = transpose(squeeze(arr(latind,:,:)));
    size(plot_arr)
    

    startdate = datetime(2009,01, 01); 

    lentime = size(plot_arr,1);
    hhh = 0:(lentime-1);
    hrs = hours(hhh*6);
    dts = startdate + hrs;

    unw = (reshape(w, 240, 41).^-1);
    
    lim_pos = max(abs(plot_arr), [], "all");
    size(unw(:,latind))
    size(plot_arr)
    
    formatted = unw(:,latind).*transpose(plot_arr);
    formatted = transpose(formatted);

    timefreq = fftshift(fftfreq(size(arr,2), 0.25));
    spacefreq = fftshift(fftfreq(240, 1/240)); %i.e. wavenumber
    transformed = fftn(formatted);


    % make the hov
    figure('position', [1, 1, 500, 1000]);
    caxis manual
    colormap jet
    caxis([-1*lim_pos lim_pos]);
    contourf(lon, datenum(dts(1:totall)), formatted(1:totall, :), 30,'LineColor', 'none')
    h = colorbar;
    xlabel("deg E")
    ylabel("date")
    ylabel(h, 'z500 comp (m/s)');
    yt = yticks;
    yticklabels(datestr(yt));
    print('-dpng','-r500',savename)
    close



    % also plot the spectra
    figure('position', [1, 1, 1000, 600])
    contourf(timefreq,spacefreq, fftshift(log(abs(transformed))), 30,'LineColor', 'none')
    %colormap(flipud(pink))
    colormap(jet)
    ylabel("frequency (day^-1)")
    xlabel("wavenumber")
    xlim([-120, 120])
    ylim([0, 0.5])
    title("rec with phi " + string(wantrec))

    h = colorbar;
    ylabel(h, 'power');
    print('-dpng','-r500',savename_spectra);
    close;

end