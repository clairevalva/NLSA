%z     = getKoopmanEigenfunctions( model );
% uZ    = getKoopmanProjectedData( model );
isz = true;
savepre = "/kontiki6/cnv5172/NLSA/examples/blocking/figs/eigenfunctions/distribs/distrib_zeig_real_z500_09to15_";
numeigs = 300; %int(size(phi,2));
%unw = reshape(w, 240, 41).^-1;
%toplot = real(reshape(z, [],240, numeigs)); % check if this is the proper order?

nY = 41;
dLat = 1.5;
lat = 30 + ( 0 : nY - 1 ) * dLat;

nX = 240;
dLon = 1.5;
lon = ( 0 : nX - 1 ) * dLon;

%mm = max(abs(real(z)), [], 'all')

for i = 2:100

    toplot = squeeze(real(z(:,i)));%*unw(lonsave,:));)
    mm = max(abs(toplot))
    hfig = figure('visible','off');
    figure('position', [1, 1, 500, 500])
    histogram(toplot,'Normalization','probability', 'EdgeColor', 'none','FaceAlpha',0.7)
    xlabel("gph comp")
    ylabel("density")
    xlim([-1*mm, mm])
    savename = savepre + string(i) + ".png"

    print('-dpng','-r500',savename)

end 