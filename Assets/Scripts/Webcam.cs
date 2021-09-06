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

    [SerializeField] [Range(0,1)] float _Invert;
    [SerializeField] [Range(0, 3)] float _Brightness;
    [SerializeField] [Range(0, 10)] float _Speed;
    [SerializeField] [Range(0, 1)] float _Grain;
    [SerializeField] [Range(0, 4)] float _Contrast;
    [SerializeField] [Range(0, 20)] float _Shift;

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

        _effectMaterial.SetFloat("_Invert", _Invert);
        _effectMaterial.SetFloat("_Brightness", _Brightness);
        _effectMaterial.SetFloat("_Speed", _Speed);
        _effectMaterial.SetFloat("_width", _webcam.width);
        _effectMaterial.SetFloat("_height", _webcam.height);
        _effectMaterial.SetFloat("_Grain", _Grain);
        _effectMaterial.SetFloat("_Contrast", _Contrast);
        _effectMaterial.SetFloat("_Shift", _Shift);
        Graphics.Blit(_webcam, _output, _effectMaterial);
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(_output, destination);
    }
}
