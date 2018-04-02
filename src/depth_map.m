function bound_fogged = depth_map(fogged, bound_fogged, reg_param, val)

[nRows, nCols] = size(bound_fogged);

% various filters to be applied
nsz = 3; total = nsz * nsz;
d{1} = [5, 5, 5; -3, 0, -3; -3, -3, -3];
d{2} = [-3, 5, 5; -3, 0, 5; -3, -3, -3];
d{3} = [-3, -3, 5; -3, 0, 5; -3, -3, 5];
d{4} = [-3, -3, -3; -3, 0, 5; -3, 5, 5];
d{5} = [5, 5, 5; -3, 0, -3; -3, -3, -3];
d{6} = [-3, -3, -3; 5, 0, -3; 5, 5, -3];
d{7} = [5, -3, -3; 5, 0, -3; 5, -3, -3];
d{8} = [5, 5, -3; 5, 0, -3; -3, -3, -3];

% normalizing filters
num_filters = length(d); 
for k = 1 : num_filters
    d{k} = d{k} / norm(d{k}(:));
end

% calculating weighting function
for k = 1 : num_filters
    weight{k} = weight_function(fogged, d{k}, val);
end

Tf = fft2(bound_fogged);
DS = 0; 
for k = 1 : num_filters
    D{k} = psf2otf(d{k}, [nRows, nCols]);
    DS = DS + abs(D{k}).^2;
end

xponent = 1; xponent_rate = 2 * sqrt(2);
xponent_max = 2^8;

while xponent < xponent_max
   
    gamma = reg_param / xponent;

    DU = 0;
    for k = 1 : num_filters
        dt{k} = imfilter(bound_fogged, d{k}, 'circular');
        u{k} = max(abs(dt{k}) - weight{k} / xponent / num_filters, 0) .* sign(dt{k}); 
        DU = DU + fft2(imfilter(u{k}, flipud(fliplr(d{k})), 'circular')); 
    end

    bound_fogged = abs(ifft2((gamma * Tf + DU) ./ ( gamma + DS)));  

    xponent = xponent * xponent_rate;
end



%%
function Weight = weight_function(fogged, D, val)
fogged = double(fogged) / 255;
d_r = imfilter(fogged(:, :, 1), D, 'circular');
d_g = imfilter(fogged(:, :, 2), D, 'circular');
d_b = imfilter(fogged(:, :, 3), D, 'circular');
Weight = exp(-(d_r.^2 + d_g.^2 + d_b.^2) / val / 2);
