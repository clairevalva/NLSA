hfig = figure('visible','off');
figure('position', [1, 1, 300, 300])
scatter(real(gamma), imag(gamma));
xlabel("real")
ylabel("imag")
print('-dpng','-r500',"figs/koopman_eigvalues.png")