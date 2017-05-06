# Fog-Removal-using-dark-channel-Prior
This Repository contains code for fog removal from a single image using dark channel prior.

Authors @ Vaibhav Khandelwal and Divyanshi Mangal
Follow the steps below to run the code:
1. Save all files in the same folder. 
2. Open fog_removal_main.m in matlab and edit the path of your input image in imread('your_input_image_path').
3. Run fog_removal_main.m.
4. Congratulations! You just defogged your Image.  

Explaination of Code:

1. First the code reads the input image in variable "fogged".
2. Then it estimates the global airlight which is the brightest pixel in the whole image.
3. Then it calculates the dark channel prior with a patch size of 3x3.
4. After applying boundary constraints on the image, it calculates the transmission Map of the Image.
5. Finally, the defogged image is recovered from the foggy input image.
