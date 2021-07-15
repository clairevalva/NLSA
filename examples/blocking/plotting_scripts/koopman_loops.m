z     = getKoopmanEigenfunctions( model );
numeigs = 16; %int(size(phi,2));
toplot = reshape(z, [],240, 16); % check if this is the proper order?
startdate = datetime(2012,01, 01); 

lentime = size(toplot,1);
hhh = 0:(lentime-1);
hrs = hours(hhh*6);
dts = startdate + hrs;


for k = 1:10
    figure('position', [1, 1, 1000, 1000])
    for i = 1:numeigs
        subplot( numeigs/4,4, i );
        plot(real(toplot(:,k*24,i)), imag(toplot(:,k*24,i))) 
        if i == 1
            title([append('koopman eigen ', int2str(i) ), ... 
            append("start: " , string(dts(1)), " end: ", string(dts(lentime - 1)))])
        else
            title(append('koopman eigen ', int2str(i) ))
        end
     
        %ytickformat('%d');
        ax = gca;
        ax.FontSize = 6;
        axis('equal')

    end 
    savename ="/kontiki6/cnv5172/NLSA/examples/blocking/figs/eigenfunctions/kloops_z500_embed20_12to13_" + string(k*24) + "E.png";
    print('-dpng','-r300',savename)
    close
end 


