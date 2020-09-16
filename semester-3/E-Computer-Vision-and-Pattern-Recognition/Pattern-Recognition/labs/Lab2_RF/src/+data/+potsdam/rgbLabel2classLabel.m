function [labelImage] = rgbLabel2classLabel(rgbLabelImage)
%RGB2LABEL Summary of this function goes here
%   Detailed explanation goes here

% Label -> class name -> RGB:
%    1: Impervious surfaces (RGB: 255, 255, 255)
%    2: Building (RGB: 0, 0, 255)
%    3: Low vegetation (RGB: 0, 255, 255)
%    4: Tree (RGB: 0, 255, 0)
%    5: Car (RGB: 255, 255, 0)
%    6: Clutter/background (RGB: 255, 0, 0)

    r = rgbLabelImage(:,:,1);
    g = rgbLabelImage(:,:,2);
    b = rgbLabelImage(:,:,3);

    imp_surf = ((r == 255) & (g == 255) & (b == 255));
    building = ((r ==   0) & (g ==   0) & (b == 255));
    low_veg  = ((r ==   0) & (g == 255) & (b == 255));
    tree     = ((r ==   0) & (g == 255) & (b ==   0));
    car      = ((r == 255) & (g == 255) & (b ==   0));
    clutter  = ((r == 255) & (g ==   0) & (b ==   0));

    labelImage = 1 * imp_surf + ...
                 2 * building + ...
                 3 * low_veg + ...
                 4 * tree + ...
                 5 * car + ...
                 6 * clutter;
end

