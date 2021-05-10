touse = z;
nameoftoplot = "z";
numeigs = 32;
startdate = datetime(2009,01, 01); 

save_pre = "/kontiki6/cnv5172/NLSA/examples/blocking/figs/spectra/spectra_" + nameoftoplot;
unw = reshape(w, 240, 41).^-1;
touse = reshape(touse, [],240, numeigs);

transformed = zeros(size(touse));
for j = 1:numeigs
    transformed(:,:,j) = fftn(touse(:,:,j));
end

timefreq = fftshift(fftfreq(size(touse,1), 0.25));
spacefreq = fftshift(fftfreq(size(touse, 2), 1/240)); %i.e. wavenumber

for j = 1:32
    savename = save_pre + "_" + string(j) + ".png";
    hfig = figure('visible','off');
    
    figure('position', [1, 1, 1000, 600])
    contourf(spacefreq,timefreq, fftshift(log(abs(transformed(:,:,j)))), 30,'LineColor', 'none')
    %colormap(flipud(pink))
    colormap(jet)
    ylabel("frequency (day^-1)")
    xlabel("wavenumber")
    xlim([-120, 120])
    ylim([0, 0.5])
    title(nameoftoplot + " eigen " + string(j))

    h = colorbar;
    ylabel(h, 'power');
    print('-dpng','-r500',savename);
    close;
end
