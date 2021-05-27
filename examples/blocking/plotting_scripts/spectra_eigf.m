touse = z;
nameoftoplot = "z";
numeigs = 300;
startdate = datetime(2009,01, 01); 

save_pre = "/kontiki6/cnv5172/NLSA/examples/blocking/figs/spectra/nolog/spectra_eigf_nolog" + nameoftoplot;
unw = reshape(w, 240, 41).^-1;
touse = reshape(touse, [],240, numeigs);

transformed = zeros(size(touse));
for j = 1:numeigs
    transformed(:,:,j) = fftn(touse(:,:,j));
end

timefreq = fftshift(fftfreq(size(touse,1), 0.25));
spacefreq = fftshift(fftfreq(size(touse, 2), 1/240)); %i.e. wavenumber

for j = 2:100
    savename = save_pre + "_" + string(j) + ".png";
    hfig = figure('visible','off');
    
    figure('position', [1, 1, 1000, 1000])
    contourf(spacefreq,timefreq, fftshift(abs(transformed(:,:,j))), 30,'LineColor', 'none')
    xline(0)
    %colormap(flipud(pink))
    colormap(jet)
    ylabel("frequency (log(day^-1))")
    xlabel("wavenumber")
    xlim([-120, 120])
    %ylim([0, 2])
    %set(gca, 'YScale', 'log')
    symlog('y',-1)
    title(nameoftoplot + " eigen " + string(j))

    h = colorbar;
    ylabel(h, 'log(power)');
    print('-dpng','-r500',savename);
    close;
end
