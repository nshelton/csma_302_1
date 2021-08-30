# MJS Shader
 

## Blur 
 
This effect applies a blur to the output video feed by using an image as a texture and overlaying it. The blur can be adjusted by the number of iterations that is being performed on the average of each pixel's color with its other 8 adjacent pixels. 


## Resolution
 
This effect helps to improve the blur as it adds an option to directly change the output of the output in order to save your computer some processing power by using less iterations when your blurring any image.


## Color Overlay (Warm)

This effect overlays a simple gradient to the output webcam which contains a warmer color tone. This is achieved my multiplying the uv colors with the texture input.


## Color Overlay (Cool)
 
Much like the effect above this one also shows a gradient but this time with cooler color tones. This is achieved my dividng the uv colors with the texture input.


## Distortion
 
This a fun image effect where you can use any image preferably seamless textures as they work the best to overlay onto your webcam. It includes a magnitude slider that changes how much of the properies the output video inherits from the texture being overlayed. 


## GrayScale
 
Fairly simple effect that applies a grayscale to the webcam output. 


## Brightness
 
Adjusts the brightness of the webcam output via slider


## Contrast
 
Adjusts the contrast of the webcam output via slider


## Invert
 
Adjusts the invert of the webcam output via slider


## Color offset
 
Offsets each value of rgb in order to get a cool effect where the colors are slightly offset from each other and sort of stacked like a rainbow. 

