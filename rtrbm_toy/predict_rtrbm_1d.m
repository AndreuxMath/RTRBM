function [vt, rt] = predict_rtrbm_1d( v1, rtrbm, mode)

% given rtrbm, and initial states v1 (up to size(v1,2)
% infer the sequence up to t=T
% every generated testing sequence is averaged from num_iter many trails

% 02/07/2015: Modification by Mathieu Andreux (added 3rd input = mode)
% mode = 1: prediction is made with the most probable sample (from gibbs)
% mode = 2 prediction is made with the mean of the gibbs samples (default)
% mode = 3 prediction is made with the last of the gibbs samples

if(nargin <3)
    mode =2;
end

pre_gibbs_k =5000;
gibbs_k = 1000;

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
    ht_k = zeros( rtrbm.d_h, gibbs_k);
    for kk = 1: gibbs_k 
        h = sigmrnd(   rtrbm.W * v + rtrbm.b + rtrbm.U * rt(:,t-1) );
        v = sigmrnd( (rtrbm.W).'*h + rtrbm.c ); 
        vt_k(:,kk) = v; 
        ht_k(:,kk) = h;
    end
    
    switch mode
        case 1
            E = sum(ht_k.*(rtrbm.W*vt_k),1) + (rtrbm.c')*vt_k + (rtrbm.b')*ht_k + (rtrbm.U * rt(:,t-1))' * ht_k;
            where = find(E==max(E));
            vt(:,t) = vt_k(:,where(1));% most probable among the samples
        case 2
            vt(:, t) = mean( vt_k, 2); % mean over the gibbs sampling path
        case 3
            vt(:, t) = vt_k(:, gibbs_k); % last observed
    end
    rt(:, t) = sigm( rtrbm.W * vt(:,t)  + rtrbm.b + rtrbm.U *rt(:, t-1));
end




