phi   = getDiffusionEigenfunctions( model ); % can comment this out if want to load else
%z     = getKoopmanEigenfunctions( model );
isz = true;
savepre = "/kontiki6/cnv5172/NLSA/examples/blocking/figs/reconstructions/hov_lon36_phi_";
numeigs = 16; %int(size(phi,2));
lonsave = 24;

unw = reshape(w, 240, 41).^-1;
toplot = reshape(phi, 41, [],240, 16); % check if this is the proper order?
startdate = datetime(2012,01, 01); 

lentime = size(toplot,2);
hhh = 0:(lentime-1);
hrs = hours(hhh*6);
dts = startdate + hrs;

nY = 41;
dLat = 1.5;
lat = 30 + ( 0 : nY - 1 ) * dLat;

nX = 240;
dLon = 1.5;
lon = ( 0 : nX - 1 ) * dLon;



for i = 1:2 %1:numeigs

    formatted = squeeze(toplot(i,:,lonsave,:)*unw(lonsave,:));
    size(formatted)

    hfig = figure('visible','off');
    figure('position', [1, 1, 500, 1000])
    contourf(dts, lat , formatted, 30,'LineColor', 'none')
    xlabel("date")
    ylabel("deg E")
    yt = xticks;
    xticklabels(datestr(yt));
    h = colorbar;
    ylabel(h, 'z500 comp (m)');
    savename = savepre + string(i) + ".png"

    print('-dpng','-r500',savename)

end 