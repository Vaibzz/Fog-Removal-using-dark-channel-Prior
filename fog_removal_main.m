% ELIMINATION OF FOG IN SINGLE IMAGE USING DARK CHANNEL PROIOR
% AUTHORS @ VAIBHAV KHANDELWAL(15BCE0342) AND DIVYANSHI MANGAL(15BCE0454)

fogged = imread('your_input_image_path'); %Fogged Image
figure, imshow(fogged);

%STEP.1. ESTIMATION OF GLOBAL AIRLIGHT.
frame = 10; % Local Patch Size
for k = 1 : 3
    minimum_intense = ordfilt2(double(fogged(:, :, k)), 1, ones(frame), 'symmetric');
    Airlight(k) = max(minimum_intense(:));
end

%STEP.2. CALCULATION OF DARK CHANNEL AND APPLY BOUNDARY CONSTRAINT
frame = 3; 
bounded_fogged = boundary_constraint(fogged, Airlight, 30, 300, frame);
figure, imshow(bounded_fogged, []),title('Constraint Bounded Dark Channel Prior Image');

%STEP.3. TRANSMISSION MAP CALCULATION.
reg_param = 2;  % regularization parameter.
t = depth_map(fogged, bounded_fogged, reg_param, 0.5); 
figure, imshow(1-t, []); colormap hot,title('Transmission Map');

%STEP.4. RECOVERY OF DE-FOGGGED IMAGE.
defog_param = 0.85;
t = max(abs(t), 0.0001).^defog_param;
fogged = double(fogged);
if length(Airlight) == 1
    Airlight = Airlight * ones(3, 1);
end
R = (fogged(:, :, 1) - Airlight(1)) ./ t + Airlight(1); 
G = (fogged(:, :, 2) - Airlight(2)) ./ t + Airlight(2); 
B = (fogged(:, :, 3) - Airlight(3)) ./ t + Airlight(3); 
defogged = cat(3, R, G, B) ./ 255;

figure, imshow(defogged, []),title('Final Defogged Image');
