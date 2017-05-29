%% 
% explore all permutations.

addpath('toolbox/');
rep = 'results/permutations/';
if not(exist(rep))
    mkdir(rep);
end

do_round = 0;
p_exp = 1.05; % exposant for transport

N = 6;
N = 70;
N = Inf; 

name = 'paris.jpg';
f = imread(name);


col = {'r' 'b'};
ms = 40;

if N==6
    load n6-positions
elseif N==Inf
    clf; imagesc(f); axis image; axis off; colormap gray(256);
    hold on;
    A = {[] []};
    for k=1:2
        s = 0;
        while s<N
            s = s+1;
            [x,y,b] = ginput(1);
            if b~=1
                break;
            end
            plot(x,y,'.', 'color', col{k}, 'MarkerSize', ms);
            A{k}(:,end+1) = [x;y];
        end
        N = size(A{k},2);
    end
else
    [n,p] = size(f);
    A{1} = [rand(1,N)*p;rand(1,N)*n];
    A{2} = [rand(1,N)*p;rand(1,N)*n];    
end


clf; imagesc(f); axis image; axis off; colormap gray(256);
hold on;
for k=1:2
	plot(A{k}(1,1:N),A{k}(2,1:N),'.', 'color', col{k}, 'MarkerSize', ms);
    for i=1:N
        text(A{k}(1,i)+25,A{k}(2,i),num2str(i), 'FontSize', 24, 'FontWeight', 'bold', 'color', col{k});
    end
end
saveas(gcf, [rep 'n' num2str(N) '-input-seeds.png'], 'png');

% distance matrix
c = distmat(A{1},A{2}).^p_exp;
c = c/max(c(:))*35;
if do_round
    c = round(c);
end

% best 
figure(1); 
[S,Cost] = Hungarian(c); p = mat2perm(S);
cost = perm_cost(p,c);
clf; plot_permutation(p,A,f);
saveas(gcf, [rep 'n' num2str(N) '-best.png'], 'png');

% worst
figure(2); 
[S,Cost] = Hungarian(-c);  p = mat2perm(S);
cost_worst = -perm_cost(p,-c);
clf; plot_permutation(p,A,f);
saveas(gcf, [rep 'n' num2str(N) '-worst.png'], 'png');

if N>=7
    return;
end

P = perms(1:N);
for i=1:size(P,1)
    progressbar(i, size(P,1));
    p = P(i,:);
    cost = perm_cost(p,c);
    if cost<cost_worst/2       
        clf;
        plot_permutation(p,A,f);
        saveas(gcf, [rep num2str(cost) '.png'], 'png');
    end
end