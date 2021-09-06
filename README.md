# MJS Shader
 

## Blur 
 
This effect applies a blur to the output video feed by using an image as a texture and overlaying it. The blur can be adjusted by the number of iterations that is being performed on the average of each pixel's color with its other 8 adjacent pixels. 

Instructions: make sure the blur script is turned on in the inspector when you click on the webcam in the scene. Drag and drop the blur image effect on the material called myMaterial. Make sure the webcam is clicked on when you hit play and scroll down to the blur script and adjust the iterations slider. You can change the resolution with the slider under it to help with the blur effect.


## Resolution
 
This effect helps to improve the blur as it adds an option to directly change the output of the output in order to save your computer some processing power by using less iterations when your blurring any image. 

Instructions: make sure the blur script is turned on in the inspector when you click on the webcam in the scene. Drag and drop the blur image effect on the material called myMaterial. Make sure the webcam is clicked on when you hit play and scroll down to the blur script and adjust the resolution slider. You can change the iterations with the slider under it to help with the blur effect.


## Color Overlay (Warm)

This effect overlays a simple gradient to the output webcam which contains a warmer color tone. This is achieved my multiplying the uv colors with the texture input. 

Instructions: drag and drop the color overlay 1 image effect onto myMaterial and hit play. Make sure to check if the brightness is not 0 in the inspector or you will not see anything. You might also have to change the contrast which is also located in the webcam script attached to the webcam object.


## Color Overlay (Cool)
 
Much like the effect above this one also shows a gradient but this time with cooler color tones. This is achieved my dividng the uv colors with the texture input. 

Instructions: drag and drop the color overlay 2 image effect onto myMaterial and hit play. Make sure to check if the brightness is not 0 in the inspector or you will not see anything. You might also have to change the contrast which is also located in the webcam script attached to the webcam object.


## Distortion
 
This a fun image effect where you can use any image preferably seamless textures as they work the best to overlay onto your webcam. It includes a magnitude slider that changes how much of the properies the output video inherits from the texture being overlayed. 

Instructions: Drag and drop the Distort Image effect onto the material called customMaterial and then click on the customMaterial in the assests folder to open it in the inspector. There you will find the magnitude slider bar and the texture that is being used as noise. Make sure you click on the webcam object to open in inspector and drag and drop the customMaterial material into the appropriate spot in the webcam script. Then hit play and adjust the magnitude with the slider and view the results.


## GrayScale
 
Fairly simple effect that applies a grayscale to the webcam output. 

Instructions: Drag and drop the grayscale image effect onto the material called myMaterial and make sure the webcam script is using myMaterial as its texture. Hit play and make sure the brightness is not 0 as well as the contrast in the inspector of the webcam under the webcam script.


## Brightness
 
Adjusts the brightness of the webcam output via slider. 

Instructions: Drag and drop the custom image effect onto the material called myMaterial and make sure the webcam script is using myMaterial as its texture. Hit play and make sure the brightness is not 0 as well as the contrast in the inspector of the webcam under the webcam script to view the result.


## Contrast
 
Adjusts the contrast of the webcam output via slider.  

Instructions: Drag and drop the custom image effect onto the material called myMaterial and make sure the webcam script is using myMaterial as its texture. Hit play and make sure the brightness is not 0 as well as the contrast in the inspector of the webcam under the webcam script to view the result.


## Invert
 
Adjusts the invert of the webcam output via slider. 

Instructions: Drag and drop the custom image effect onto the material called myMaterial and make sure the webcam script is using myMaterial as its texture. Hit play and make sure the brightness is not 0 as well as the contrast in the inspector of the webcam under the webcam script to view the result.


## Color offset
 
Offsets each value of rgb in order to get a cool effect where the colors are slightly offset from each other and sort of stacked like a rainbow. 

Instructions: Drag and drop the custom image effect onto the material called myMaterial and make sure the webcam script is using myMaterial as its texture. Hit play and make sure the brightness is not 0 as well as the contrast in the inspector of the webcam under the webcam script to view the result.



# Favorite Image Effect Combination
![ImageEffectScreenshot](https://user-images.githubusercontent.com/57106179/132158895-65d7585f-d1eb-4a85-8f58-e39603569eaf.png)
