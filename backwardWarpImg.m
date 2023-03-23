function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
                                              dest_canvas_width_height)
	src_height = size(src_img, 1);
	src_width = size(src_img, 2);
    src_channels = size(src_img, 3);
    dest_width = dest_canvas_width_height(1);
	dest_height	= dest_canvas_width_height(2);
    
    result_img = zeros(dest_height, dest_width, src_channels);
    mask = false(dest_height, dest_width);
    
    % this is the overall region covered by result_img
    [dest_X, dest_Y] = meshgrid(1:dest_width, 1:dest_height);
    
    % map result_img region to src_img coordinate system using the given
    % homography.
    src_pts = applyHomography(resultToSrc_H, [dest_X(:), dest_Y(:)]);
    src_X = reshape(src_pts(:,1), dest_height, dest_width);
    src_Y = reshape(src_pts(:,2), dest_height, dest_width);
    
    % ---------------------------
    % START ADDING YOUR CODE HERE
    % ---------------------------
    
    % Set 'mask' to the correct values based on src_pts.
    mask =  src_X>0 & src_X <= src_width &src_Y>0 & src_Y <= src_height;
    % fill the right region in 'result_img' with the src_img
    valid_x = src_X.*mask;
    valid_y = src_Y.*mask;

    for i = 1:3
        src = squeeze(src_img(:,:,i));
        [src_X, src_Y] = meshgrid(1:src_width, 1:src_height);
        result_img(:,:,i) = interp2(src_X, src_Y, src, valid_x, valid_y);
    end

    result_img(isnan(result_img))=0;
    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------
end