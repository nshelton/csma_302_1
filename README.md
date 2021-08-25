# Basic Video Effect Shaders
here we're going to write shaders that will the video coming out of your webcam live for our online class video chat!

The final assignment should be submitted by Friday August 3 at midnight.

## Setup

install NewTek [NDI tools](https://www.ndi.tv/tools/#download-tools) 
Run the installed "Webcam Input" program. This will turn an NDI feed into a webcam.

## Render Pipeline

1. In the Unity project, the webcam comes in through the `Webcam` Script on the `Webcam` GameObject. 
2. Hit Play
3. You'll need to set the "Selected Device" to the webcam you want to use.
4. Inside the webcam script, the image is copied into a texture called `MyOutputTexture` using `Graphics.Blit()`
5. The `NDI Sender` component takes the `MyOutputTexture`  and sends it over NDI
6. The "Webcam Input" NDI utility program takes the texture and sends the vide stream as a virtual webcam. You have to go into the tray and be sure Unity is selected)
7. Change your discord settings to use `NewTek NDI Video` as your webcam
8. ??? Profit

Note: There is a Camera also in the scene, this is just used to see the webcam in Unity and is not necessary for the filter.

webcam -> Unity WebCamTexture -> (filter shader) -> MyOutputTexture (RenderTexture asset in Unity) -> NDI sender

## Grading

You will implement 10 image filters on the webcam. These could be triggered by sliders in the Inspector, or keyboard keys, MIDI ???  whatever you feel like

8 points per effect implemented (up to 10)
10 points for project organization ( top-level folders),  short README describing the effects and how the UI works.
10 points for code organization (indentation, comments, descriptive variable names, creating functions for each effect)

you are free to copy-paste shader code that you find on the internet for your effects, just be sure that you include a link to the site it is from. But the entire effect cannot be copy-pasted, just helper functions like HSVtoRGB or something like that. you have to do something else to the output besides 


## Filter Ideas

we'll do a few in class, and you will be responsible for doing the rest on your own.

Brightness
Contrast
Blurring
Sharpening
Edge Detection
Hue Rotate
Grayscale
Sepia
Channel Mix - swap Red and Blue, etc
Tint
Gradient Overlay
Chroma Shift
Image displacement or distortion (sine wave, noiose function, etc)
Add Noise ( film grain)
Multiply by another image ( mask)
Mask with geometric primitive
Invert
Scanlines
Pixelize

More inspiration here : 
https://github.com/vanruesc/postprocessing
https://docs.unity3d.com/Manual/PostProcessingOverview.html

let me know if you have any questions, many of these effects are for 3D renders and not really suitable for a webcam Image (for example, fog, SSAO, reflections) or are too copmlicated for the first assignment., but I'd be happy to explain any of them.


## Submitting 
(this is also in the syllabus, but consider this an updated version)

1. Disregard what the Syllabus said about Moodle, just submit your work to a branch on github on this repo (branch should be your firstname-lastname)
When you are finished, "Tag" the commit in git as "Complete". You can still work on it after that if you want, I will just grade the latest commit.

2. The project has to run and all the shaders you are using should compile. If it doesn't I'm not going to try to fix it to grade it, I will just let you know that your project is busted and you have to resubmit.  Every time this happens I'll take off 5%. You have 24 hours from when I return it to get it back in, working. 

3. Late projects will lose 10% every 24 hours they are late, after 72 hours the work gets an F. 

4. Obviously plagarism will not be tolerated, there are a small number of students so I can read all your code. Because it is on git it's obvious if you copied some else's. If youo copoy cde without citing the source in a coomment, this will be considered plagarism. 






