using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Blurring : MonoBehaviour
{
    public Material BlurMaterial;
    [Range(0, 10)]
    public int Iterations;  //the iterations is how many times the code will apply the material (blur iterations)
    [Range(0, 4)]
    public int DownRes; //this will control the resolution of the image so that we can reduce it to create more of a blur without using so much processing power on thousands of iterations

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        int width = src.width >> DownRes; //the image will be scaled down in twos by using bit-shifting
        int height = src.height >> DownRes; //the image will be scaled down in twos by using bit-shifting

        RenderTexture rt = RenderTexture.GetTemporary(width, height); //temporary render texture that is the same width-height as our source
        Graphics.Blit(src, rt);

        for (int i = 0; i < Iterations; i++)    //this will store the temporary textures for as many iterations as we have until we reach our desired effect
        {
            RenderTexture rt2 = RenderTexture.GetTemporary(width, height);
            Graphics.Blit(rt, rt2, BlurMaterial);
            RenderTexture.ReleaseTemporary(rt);
            rt = rt2;
        }

        Graphics.Blit(rt, dst);
        RenderTexture.ReleaseTemporary(rt);
    }
}



// Reference to the video at this link: https://www.youtube.com/watch?v=kpBnIAPtsj8