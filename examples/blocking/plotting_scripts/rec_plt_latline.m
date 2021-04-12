plotx = reshape(newx, 41, [], 240);
unw = reshape(w, 240, 41).^-1;
latline = 186; % about 80 W, want to see march washington heat wave"
savename = "/kontiki6/cnv5172/NLSA/examples/blocking/figs/reconstructions/diff_2to12_z500_80W_embed50.png";
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

formatted = squeeze(transpose(plotx(:,:,latline)).*unw(latline,:));

hfig = figure('visible','off');
figure('position', [1, 1, 1000, 500])
contourf(dts, lat , transpose(formatted), 30,'LineColor', 'none')
ylabel("deg N")
xlabel("date")
yt = xticks;
xticklabels(datestr(yt));
h = colorbar;
ylabel(h, 'z500 comp (m)');

print('-dpng','-r500',savename)