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

    [SerializeField] [Range(0, 5)] float _Brightness;
    [SerializeField] [Range(0, 1)] float _Invert;
    [SerializeField] [Range(0, 10)] float _Shift;
    [SerializeField] [Range(0, 1)] float _CamTransition;
    [SerializeField] [Range(0, 1)] float _Perspective;
    [SerializeField] [Range(0, 1)] float _Grayscale;
    [SerializeField] [Range(0, 1)] float _RedOverlay;
    [SerializeField] [Range(0, 1)] float _Blur;
    [SerializeField] [Range(0, 1.0f)] float _Displace;
    
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
        if ( _currentDevice != _selectedDevice)
        {
            _webcam.Stop();
            _currentDevice = _selectedDevice;
            _webcam = new WebCamTexture(_devices[_currentDevice]);
            _webcam.Play();
        }
        
        _effectMaterial.SetFloat("_Brightness", _Brightness);
        _effectMaterial.SetFloat("_Invert", _Invert);
        _effectMaterial.SetFloat("_Shift", _Shift);
        _effectMaterial.SetFloat("_CamTransition", _CamTransition);
        _effectMaterial.SetFloat("_Perspective", _Perspective);
        _effectMaterial.SetFloat("_Grayscale", _Grayscale);
        _effectMaterial.SetFloat("_RedOverlay", _RedOverlay);
        _effectMaterial.SetFloat("_Blur", _Blur);
        _effectMaterial.SetFloat("_Displace", _Displace);

        _effectMaterial.SetFloat("_Width", _webcam.width);
        _effectMaterial.SetFloat("_Height", _webcam.height);
        Graphics.Blit(_webcam, _output, _effectMaterial);
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(_output, destination);
    }
}
