
 x     =getData(model.srcComponent); 
% toload   =  getProjectedData( model );
test = reshape(toload(:,1), [],20);
% test = reshape(x, 41, [], 240);


figure('position', [1, 1, 300, 300])
%contourf(squeeze(test(:,3,:)))
contourf(squeeze(test))
colorbar;
print('-dpng','-r300',"/kontiki6/cnv5172/NLSA/examples/blocking/figs/test_projection.png")