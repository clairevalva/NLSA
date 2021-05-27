%phi   = getDiffusionEigenfunctions( model ); % can comment this out if want to load else
%z     = getKoopmanEigenfunctions( model );
isz = true;
savepre = "/kontiki6/cnv5172/NLSA/examples/blocking/figs/eigenfunctions/morez/hov_zeig_imag_z500_09to15_";
numeigs = 300; %int(size(phi,2));
lenplot = 4000;
unw = reshape(w, 240, 41).^-1;
toplot = imag(reshape(z, [],240, numeigs)); % check if this is the proper order?
startdate = datetime(2009,01, 01); 

lentime = size(toplot,1);
hhh = 0:(lentime-1);
hrs = hours(hhh*6);
dts = startdate + hrs;

nY = 41;
dLat = 1.5;
lat = 30 + ( 0 : nY - 1 ) * dLat;

nX = 240;
dLon = 1.5;
lon = ( 0 : nX - 1 ) * dLon;



for i = 2:100

    formatted = squeeze(toplot(:,:,i));%*unw(lonsave,:));)
    size(formatted);
    mm = max(abs(formatted), [], "all")
    hfig = figure('visible','off');
    figure('position', [1, 1, 500, 1000])
    contourf(lon, datenum(dts(1:lenplot)), formatted(1:lenplot, :), 30,'LineColor', 'none')
    xlabel("deg E")
    ylabel("date")
    yt = yticks;
    yticklabels(datestr(yt));
    h = colorbar;
    caxis([-1*mm, mm])
    ylabel(h, 'z500 comp (m/s)');
    savename = savepre + string(i) + ".png"

    print('-dpng','-r500',savename)

end 