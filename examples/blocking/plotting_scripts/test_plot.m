
% T     = abs(getKoopmanEigenperiods( model ))/5;
% rightlen = (T <= 21);
% okinds = 1:length(T);
% okinds = okinds(rightlen);

%x     =getData(model.srcComponent); 
% toload   =  getProjectedData( model );
%test = reshape(toload(:,1), [],20);
% test = reshape(x, 41, [], 240);
%gamma = getKoopmanEigenvalues( model ) * 20 / (2*pi);


figure('position', [1, 1, 1200, 600])
pointsize = 30;
plot((1:4000)/4, toplot(1:4000,100,12));
% %contourf(squeeze(test(:,3,:)))
% scatter(1:length(T), abs(T)/5)
% xlabel("eigenfunction number")
colorbar;
% set(gca, 'YScale', 'log')
print('-dpng','-r300',"/kontiki6/cnv5172/NLSA/examples/blocking/figs/test_MJO.png")