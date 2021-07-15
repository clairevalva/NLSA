%phi   = getDiffusionEigenfunctions( model ); % can comment this out if want to load else
z     = getKoopmanEigenfunctions( model );
isz = true;

numeigs = 300; %int(size(phi,2));
toplot = reshape(z, [],240, numeigs); % check if this is the proper order?
startdate = datetime(2012,01, 01); 

lentime = size(toplot,1);
hhh = 0:(lentime-1);
hrs = hours(hhh*6);
dts = startdate + hrs;


for k = 1:10
    figure('position', [1, 1, 1000, 1000])
    for i = 1:numeigs
        subplot(numeigs/4,4, i );
        plot(transpose(dts(1,:)), real(toplot(:,k*24,i)), 'DisplayName', "real");

        if isz
            hold on
            plot(transpose(dts(1,:)), imag(toplot(:,k*24,i)), 'DisplayName', "imag"); 
        end

        title(append('diffusion eigen ', int2str(i) ));
        ytickformat('%d');
        ax = gca;
        ax.FontSize = 8;

end 
    savename ="/kontiki6/cnv5172/NLSA/examples/blocking/figs/eigenfunctions/morez/eigk_z500_embed20_12to13_" + string(k*10) + "E.png";
    print('-dpng','-r300',savename)
    close
end 


