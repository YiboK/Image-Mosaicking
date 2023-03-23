function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
%RUNRANSAC
    num_pts = size(Xs, 1);
    pts_id = 1:num_pts;
    inliers_id = [];
    
    for iter = 1:ransac_n
        % ---------------------------
        % START ADDING YOUR CODE HERE
        % ---------------------------
        inds = randperm(num_pts, 4); % inds is a vector of 4 random unique integers in [1, n]
        n_Xs = Xs(inds,:);
        n_Xd = Xd(inds,:);
        H_3x3 = computeHomography(n_Xs, n_Xd);

        pred = applyHomography(H_3x3, Xs); % A and B are 3 x n matrices and H is a 3 x 3 matrix 
        dist = sqrt(sum((pred' - Xd').^2)); % A and B are nx3 matrices and dist is a 1xn matrix
        if length(find(dist<=eps)) > length(inliers_id)
            inliers_id = find(dist<=eps);
            H = H_3x3;
        end
        % ---------------------------
        % END ADDING YOUR CODE HERE
        % ---------------------------
    end    
end
