function [vt, rt] = predict_rtrbm_1d( v1, rtrbm)

% given rtrbm, and initial states v1 (up to size(v1,2)
% infer the sequence up to t=T
% every generated testing sequence is averaged from num_iter many trails

pre_gibbs_k = 10;
gibbs_k = 20;

%%
vt = zeros( rtrbm.d_v, rtrbm.T);
rt = zeros( rtrbm.d_h, rtrbm.T);

t1 = size( v1, 2);

vt(:, 1:t1) = v1;
rt(:, 1) = sigm( rtrbm.W * v1(:,1) + rtrbm.b0 );
for t = 2:t1
    rt(:, t) = sigm( rtrbm.W * vt(:,t)  + rtrbm.b + rtrbm.U *rt(:, t-1));
end

for t = t1+1: rtrbm.T
    
    % sample vt given r_{t-1}, block gibbs sampling v and h 
    v = vt(:,t-1); %starting from previous vt
    
    for kk = 1: pre_gibbs_k 
        h = sigmrnd(   rtrbm.W * v + rtrbm.b + rtrbm.U * rt(:,t-1) );
        v = sigmrnd( (rtrbm.W).'*h + rtrbm.c ); 
    end
    
    vt_k = zeros( rtrbm.d_v, gibbs_k);
    for kk = 1: gibbs_k 
        h = sigmrnd(   rtrbm.W * v + rtrbm.b + rtrbm.U * rt(:,t-1) );
        v = sigmrnd( (rtrbm.W).'*h + rtrbm.c ); 
        vt_k(:,kk) = v; 
    end
    
    vt(:, t) = mean( vt_k, 2); % mean over the gibbs sampling path
    %vt(:, t) = vt_k(:, gibbs_k);
    rt(:, t) = sigm( rtrbm.W * vt(:,t)  + rtrbm.b + rtrbm.U *rt(:, t-1));
end




