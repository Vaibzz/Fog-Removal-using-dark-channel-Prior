function [p1, p2] = boundary_constraint(fogged, Airlight, C0, C1, frame)
% patch-wise transmission from boundary constraint

if length(Airlight) == 1
    Airlight = Airlight * ones(3, 1);
end
if length(C0) == 1
    C0 = C0 * ones(3, 1);
end
if length(C1) == 1
    C1 = C1 * ones(3, 1);
end
fogged = double(fogged);

% pixel-wise boundary
t_r = max((Airlight(1) - fogged(:, :, 1)) ./ (Airlight(1)  -  C0(1)), (fogged(:, :, 1) - Airlight(1)) ./ (C1(1) - Airlight(1) ));
t_g = max((Airlight(2) - fogged(:, :, 2)) ./ (Airlight(2)  - C0(2)), (fogged(:, :, 2) - Airlight(2)) ./ (C1(2) - Airlight(2) ));
p2 = max((Airlight(3) - fogged(:, :, 3)) ./ (Airlight(3)  - C0(3)), (fogged(:, :, 3) - Airlight(3)) ./ (C1(3) - Airlight(3) ));
p2 = max(cat(3, t_r, t_g, p2), [], 3);
p2 = min(p2, 1);

% minimum filtering
se = strel('square', frame);
p1 = imclose(p2, se);
