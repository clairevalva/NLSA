plotx = reshape(newx, 41, [], 240);
unw = reshape(w, 240, 41).^-1;
lonline = 15;
savename = "/kontiki6/cnv5172/NLSA/examples/blocking/figs/reconstructions/diff_2to12_z500.png";
startdate = datetime(2012,01, 01);

nY = 41;
dLat = 1.5;
lat = 30 + ( 0 : nY - 1 ) * dLat;

nX = 240;
dLon = 1.5;
lon = ( 0 : nX - 1 ) * dLon;

nD = size(plotx, 2);
hhh = 0:(nD-1);
hrs = hours(hhh*6);
dts = datenum(startdate + hrs);

formatted = squeeze(plotx(lonline,:,:)*unw(15,1));

hfig = figure('visible','off');
figure('position', [1, 1, 500, 1000])
contourf(lon, dts , formatted, 30,'LineColor', 'none')
ylabel("date")
xlabel("deg E")
yt = yticks;
yticklabels(datestr(yt));
h = colorbar;
ylabel(h, 'z500 comp (m)');

print('-dpng','-r500',savename)