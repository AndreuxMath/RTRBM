
% newly generate time sequences

data = video_bouncing_1d();


%%

load train1.mat
rtrbm


%%
T0 = 8;
for ii = 2: 2 : 12
    [vt1, rt1] = predict_rtrbm_1d( data(:,1:T0, ii),  rtrbm);
    
    figure(1), clf
    subplot( 1,2,1)
    imagesc( data( :, :, ii)), title(sprintf('true, ii=%d', ii));
    colormap(1-gray);
    subplot( 1,2,2)
    imagesc( vt1), title('generated');
    colormap(1-gray);
    pause();
end


ii
figure(2), 
for t = 1: rtrbm.T
    clf,
    plot( vt1(:, t), '.-');
    hold on;
    plot( data(:, t, ii), 'x-r');
    legend('predict', 'true');
    title(sprintf('t=%d',t));
    pause();
end