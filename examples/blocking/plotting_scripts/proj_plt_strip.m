% these should be hovmollers
% also will have to do this two ways, bc both in slice and at like 45 deg for looks
%toload    = getKoopmanProjectedData( model );
toload   =  getProjectedData( model ); % phi, can comment this out if want to load else

numeigs = 16; %int(size(phi,2));
toplot = reshape(toload, [],20, 16); % check if this is the proper order?

nY = 41;
dLat = 1.5;
lat = 30 + ( 0 : nY - 1 ) * dLat;

nX = 20;
dX = 0.25;
dts = ( 0 : nX - 1 )*dX;

savepre = "/kontiki6/cnv5172/NLSA/examples/blocking/figs/projections/uphi_lwa_12to13_";


for i = 1:16
    hfig = figure('visible','off');
    contourf(dts, lat , toplot(:,:,i), 30,'LineColor', 'none')
    ylabel("latitude (deg N)")
    xlabel("days")
    h = colorbar;
    ylabel(h, 'z500 comp (m)')
    title(append("vsa, uZ = ", int2str(i)))

    print('-dpng','-r500',(savepre + string(i) +  ".png"))
end
 