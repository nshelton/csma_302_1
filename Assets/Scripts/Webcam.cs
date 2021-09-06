using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Webcam : MonoBehaviour
{
    [SerializeField] RenderTexture _output;

    [SerializeField] List<string> _devices;
    [SerializeField] int _selectedDevice = 0;
    [SerializeField] Material _effectMaterial;

    [SerializeField] [Range(0,1)] float _Invert;
    [SerializeField] [Range(0,20)] float _Color_shift;
    [SerializeField] [Range(0,1)] float _Blur;
    [SerializeField] [Range(0,40)] float _DisplaceY;    
    [SerializeField] [Range(0,40)] float _DisplaceX;    
    [SerializeField] [Range(0,3)] float _Brightness;
    [SerializeField] [Range(0,1)] float _GreyscaleActive;
    [SerializeField] [Range(0,2)] float _Swizzle;
    [SerializeField] [Range(0,2)] float _Contrast;
    [SerializeField] [Range(0,1)] float _ApplyTint;
    [SerializeField, ColorUsage(true, true)] Color _Tint;


    private int _currentDevice = 0;
    private WebCamTexture _webcam;


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

        _effectMaterial.SetFloat("_width", _webcam.width);
        _effectMaterial.SetFloat("_height", _webcam.height);
        _effectMaterial.SetFloat("_Invert", _Invert);
        _effectMaterial.SetFloat("_Colorshift", _Color_shift);
        _effectMaterial.SetFloat("_Blur", _Blur);
        _effectMaterial.SetFloat("_displaceY", _DisplaceY);
        _effectMaterial.SetFloat("_displaceX", _DisplaceX);
        _effectMaterial.SetFloat("_Brightness", _Brightness);
        _effectMaterial.SetFloat("_GreyscaleActive", _GreyscaleActive);
        _effectMaterial.SetFloat("_Swizzle", _Swizzle);
        _effectMaterial.SetFloat("_Contrast", _Contrast);
        _effectMaterial.SetFloat("_ApplyTint", _ApplyTint);

        _effectMaterial.SetColor("_Tint", _Tint);
    
        
        Graphics.Blit(_webcam, _output, _effectMaterial);
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(_output, destination);
    }
}
