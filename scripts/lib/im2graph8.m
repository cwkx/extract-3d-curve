function G = im2graph8(I)
    [M, N] = size(I);
    MxN = M*N;
    C = reshape(I, MxN, 1);                                                 % Stack columns
    G = spdiags(repmat(C,1,8), [-M-1, -M, -M+1, -1, 1, M-1, M, M+1], MxN, MxN);

    % Set to inf to disconect top from bottom rows
    G(sub2ind([MxN, MxN], (2:N-1)*M+1,(2:N-1)*M - M))   = inf;              % Top->bottom westwards(-M-1)
    G(sub2ind([MxN, MxN], (1:N)*M,    (1:N)*M - M + 1)) = inf;              % Bottom->top westwards(-M+1)

    G(sub2ind([MxN, MxN], (0:N-1)*M+1,(0:N-1)*M + M))     = inf;            % Top->bottom eastwards(M-1)
    G(sub2ind([MxN, MxN], (1:N-2)*M,  (1:N-2)*M + M + 1)) = inf;            % Bottom->top eastwards(M+1)

    % Set to inf to disconect top from bottom rows
    G(sub2ind([MxN, MxN], (1:N-1)*M+1, (1:N-1)*M))     = inf;               % Top->bottom
    G(sub2ind([MxN, MxN], (1:N-1)*M,   (1:N-1)*M + 1)) = inf;               % Bottom->top
end