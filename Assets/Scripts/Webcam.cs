using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Webcam : MonoBehaviour
{
    [SerializeField] RenderTexture _output;

    [SerializeField] List<string> _devices;
    [SerializeField] int _selectedDevice = 0;
    [SerializeField] Material _effectMaterial;

    private int _currentDevice = 0;
    private WebCamTexture _webcam;


    [SerializeField] [Range(0f, 1f)] float _Invert;     //this creates a slider in the inspector that adjusts the inversion of the webcam's video output
    [SerializeField] [Range(0f, 1f)] float _Contrast;   //this creates a slider in the inspector that adjusts the contrast of the webcam video output
    [SerializeField] [Range(0f, 3f)] float _Brightness;     //this creates a slider in the inspector that adjusts the brightness of the webcam video output



    void Start()
    {
        WebCamDevice[] devices = WebCamTexture.devices;
        _devices = new List<string>();

        for (int i = 0; i < devices.Length; i++)
        {
            _devices.Add(devices[i].name);
        }

        _currentDevice = 0;

        _webcam = new WebCamTexture(devices[_currentDevice].name);
        _webcam.Play();
    }

    private void Update()
    {
        if (_currentDevice != _selectedDevice)
        {
            _webcam.Stop();
            _currentDevice = _selectedDevice;
            _webcam = new WebCamTexture(_devices[_currentDevice]);
            _webcam.Play();
        }

        _effectMaterial.SetFloat("_Invert", _Invert);
        _effectMaterial.SetFloat("_Contrast", _Contrast);
        _effectMaterial.SetFloat("_Brightness", _Brightness);


        _effectMaterial.SetFloat("_width", _webcam.width);
        _effectMaterial.SetFloat("_height", _webcam.height);

        Graphics.Blit(_webcam, _output, _effectMaterial);
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(_output, destination);
    }
}


// added on to previous work done by my Professor Nick Shelton at: https://github.com/nshelton/csma_302_1/tree/nicholas-shelton
// this code creates three sliders and makes it so that the webcam displays the visual output with a color offset as well as providing a 
// way to change brightness, inversion, and contrast to the output.