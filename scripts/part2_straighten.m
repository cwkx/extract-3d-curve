function [Bp,T] = part2_straighten(B,c,delta,omega,omicron, straighten)
%% Straighten the n*m input image B by a curve c, giving a straightened B', subject to straightening parameters delta, omega, and omicron.
%  Licensed under the GNU General Public License Version 3. 
%  Copyright 2016 Chris G. Willcocks, Durham University, UK.
warning('off','all');

%% Algorithm 2
[J,I] = meshgrid(linspace(1,size(B,2), floor(size(B,2)/omega)), ...
                 linspace(1,size(B,1), floor(size(B,1)/omega)));
V = [floor(J(:)), floor(I(:))];                                             % Grid points over B by spacing omega
if (~straighten) Bp = B; T={}; return; end                                  % The straighten process is optional for already straight images
[c_y,c_x] = ind2sub(size(B),c);                                             % Linear to subscript
q = length(c_x);                                                            % Number of centreline points
cp_x = c_x;
cp_y = zeros(length(cp_x),1)';
for i=2:q
    cp_x(i) = cp_x(i-1) + norm([c_x(i),c_y(i)]-[c_x(i-1),c_y(i-1)]);        % Straighten c to c'
end
Vp = unfolding(B,c,c_x,c_y,cp_x,cp_y,V,delta);                              % Lines 8-12
T = {[min(Vp(:,1)), max(Vp(:,1))], [min(Vp(:,2)), max(Vp(:,2))], ...        % We store all our transforms in T so we can later do the inverse
     cp2tform(V, Vp, 'lwm', omicron)};
Bp = imtransform(B, T{3}, makeresampler({'nearest','nearest'},'fill'), ...  % B' = local weighted mean transform
        'XData',T{1},'YData',T{2});
    
%% Preparation for next stage, and store all our transforms in T
Bp = rot90(Bp);                                                             % Rotate 90 degress (aesthetic)
T{4} = find(any(Bp,1),1,'first') : find(any(Bp,1),1,'last');                % Crop set pixels
T{5} = find(any(Bp,2),1,'first') : find(any(Bp,2),1,'last');
T{4} = (T{4}(1)-100) : (T{4}(end)+100);                                     % Add some padding (aesthetic only)
T{4}((T{4}<1) | (T{4}>size(Bp,2))) = [];
Bp = Bp(T{5}, T{4});

end