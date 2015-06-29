
function data = video_bouncing_1d()
% generate a video of "1d boucing ball" (boucing square wave) 

% binary vector/square wave
% warning: too few data points, may overfit 

%% 1d bouncing translating waves


L = 16;
W = [4 5 6 7]; %width of the wave
V = [1 2];
T = 32; %what is the influence of T? To have more observations: either setting T bigger, or break them into more short pieces, 
        %which case is easier to learn?

N = 256; %maximum possible number = L * (2*numel(V))* numel( W)

data = zeros( L, T, N);

for i = 1 : N
    iw = randperm( numel( W), 1);
    ww = W(iw);
    
    ff0 = zeros( L, 1);
    ff0( 1: ww ) = 1; %width
    
    u = randperm( L-ww+1, 1)-1; %initial position
    vv = V( randperm( numel( V), 1) ) * sign( randn(1)); %initial speed, vv>0 for right
    
    for t = 1 : T
        data(:, t, i) = circshift( ff0, u); 
        u = u + vv; %update location
        
        if  u  < 1 %left end and goes left
            u = -u; %bounce back
            vv = -vv; %flip velocity
          
        end
        
        if u > L-ww-1 %right end
            u = 2*(L-ww)-u; %bounce back
            vv = -vv; %flip velocity
        end 
    end
    
    
end





return;

%% periodically translating signal in one direction
%%% there is an issue when both-direction translating waves are included in
%%% data, when different size of plates and different velocities are
%%% included, then the generated sequences also vary in size and
%%% velocity...

L = 16;
W = [3 4 5 6]; %width of the wave
V = 2;
T = 10;

% initial position, totally L many posibility
% initial velocity, |v| = 1, 2, ..., W/2, and both left and right
% thus toally 2*W*L = N many samples

N = numel(W)*V*L;

% goes right
data = zeros( L, T, N);

ii = 1;

for iw = 1 : numel( W)
    ww = W(iw);
    ff0 = zeros( L, 1);
    ff0( 1: ww ) = 1;
    
    for u  = 1:L %initial position
        ff = circshift( ff0, u);
        for v = 1 : V %velocity
            v = 1;
            for t = 1 : T
                data(:, t, ii) = circshift( ff, v*t);
            end
            ii = ii +1;
            
        end
    end
end

% goes left (time reflected)
% data = cat( 3, data, data(:, end:-1:1, :));
    % and then the machine fails to learn

return;

%% visualize via video
figure(1), clf
for ii = 1: N
    
    for t = 1: T
        plot( data(:, t, ii), 'k');
        title( sprintf( 'sample %d', ii));
        pause(0.1);
    end
    pause(0.5);
end





