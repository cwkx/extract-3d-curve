function [Vp] = unfolding(B,c,c_x,c_y,cp_x,cp_y,V,delta)
%% 2D unfolding implementation based on: 
%  Yao J, Chowdhury AS, Aman J, Summers RM. Reversible Projection Technique for Colon Unfolding. IEEE Trans Biomed Eng. 57(12), 2861-9, 2010 

P = zeros(size(B));                                                         % Path image
P(c) = 1;                                                                   % CL - corresponding closest centerline point for every pixel position
[~,idx] = bwdist(P);                                                        % idx has same size as image, and stores linear indices
cidx = sub2ind(size(P),c_y,c_x);                                            % Linear indices of centreline points
CL = zeros(size(P));                                                        % cidx maps centreline point indices to their linear indices in the image
for i=1:length(cidx)                                                        % So cidx(i) = sub2ind(size(B), c_y(i), c_x(i))
    CL(idx==cidx(i)) = i;                                                   % c_y and c_x are columns, so so is cidx
end                                                                         % CL(i,j) is the index of the closest centreline point to pixel (i,j)
x = c_x(:);
y = c_y(:);
dx = gradient(x);
dy = gradient(y);
dr = [dx dy];
N = sum(abs(dr).^2,2).^(1/2);                                               % Magnitude
d = find(N==0); 
N(d) = eps*ones(size(d));
N = N(:,ones(2,1));
T = dr./N;                                                                  % Tangent
N = [-T(:,2), T(:,1), zeros(size(T,1),1)];
M = [];
M(1,1,:) = T(:,1);
M(2,1,:) = T(:,2); 
M(1,2,:) = N(:,1);
M(2,2,:) = N(:,2);
J = V(:,1);
I = V(:,2);
Vp = [];
for k = 1:length(I)
    i = I(k);                                                               % Row/column coords for k'th untransformed control point
    j = J(k);
    ixy = CL(i,j);                                                          % Index of the closest centreline point to this control point
    kr = ixy-delta:ixy+delta;                                               % Smoothing range
    kr(kr<1) = [];
    kr(kr>length(c_x)) = [];
    ds = 0;
    for k=kr                                                                % Calculate the denominator for weight w_i_k (equation 10 in referenced paper)
        ckx = c_x(k);
        cky = c_y(k);
        d = 1/norm([j-ckx,i-cky]);
        if isinf(d); d = 0; end
        ds = ds + d;
    end
    vp = [0;0];
    for k=kr
        ckx = c_x(k);
        cky = c_y(k);
        cpkx = cp_x(k);                                                     % Transformed centreline point x coord
        cpky = cp_y(k);                                                     % Transformed centreline point y coord
        d = 1/norm([j-ckx,i-cky]);
        if isinf(d); d = 0; end
        w = d/ds;                                                           % The weight w_i_k finally calculated
        m = M(:,:,k);
        vp = vp + w.* ( [cpkx,cpky]' + m\([j-ckx,i-cky]') );
    end
    Vp = [Vp; vp(1), vp(2)];
end

end