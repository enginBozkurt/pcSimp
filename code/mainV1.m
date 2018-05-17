% the main process
% simplify the point cloud with name of pcname
% Author: Junkun Qi
% 2018/5/13
clear;
time_start = clock;

dirname = 'nocolor';
pcname = fullfile(dirname,'bunny.ply');
simpname =  fullfile(dirname,'bunny-simp.ply');
alpha = 0.1;
lambda = 0.1;
eta = 0.05;
k = 15;
p_thres = 3000;

% load and split the point cloud into grids
[grid, forinit, n, sigma] = divide(pcname, alpha, p_thres);
m = 0;
X = zeros(forinit);
for i = 1:n
   disp(i);
   tmp = simplify(alpha, lambda, sigma, eta, k, grid(i).X);
   if isempty(tmp)
       continue;
   end
   range = grid(i).range;
   tmp = tmp(tmp(:,1)>range(1,1) & tmp(:,1)<range(1,2),:);
   tmp = tmp(tmp(:,2)>range(2,1) & tmp(:,2)<range(2,2),:);
   tmp = tmp(tmp(:,3)>range(3,1) & tmp(:,3)<range(3,2),:);
   t = size(tmp,1);
   X(m+1:m+t,:) = tmp;
   m = m + t;
   clear tmp;
end

disp(['m: ',num2str(m)]);
% save the simplified point cloud
if forinit(2) == 3
    pc = pointCloud(X(1:m,:));
else % == 6
    pc = pointCloud(X(1:m,1:3),'Color',X(1:m,4:6));
end
pcwrite(pc,simpname,'PLYFormat','binary');

time_end = clock;
disp(['Runtime: ',num2str(etime(time_end,time_start))]);