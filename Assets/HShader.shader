Shader "Hidden/HShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        [Toggle(PIXELATE_ENABLED)] // <- this makes the variable appear as a checkbox in the Unity inspector.
        _PixelateEnabled("Pixelate", Float) = 0
        _PixelateAmount("Mosaic Intensity", Range(0, 100)) = 100

        [Space(20)] // <-- adds a spacer to the inspector with 20 height
        [Toggle(COLOR_SWAP_ENABLED)]
        _ColorSwapEnabled("Color Swap", Float) = 0
        _ColorSwapIntensity("Tolerance", Range(0, 0.5)) = 0
        _ColorSwap1("Color Swap [Original color]", Color) = (255, 0, 0, 1)
        _ColorSwap2("Color Swap [Destination color]", Color) = (255, 0, 0, 1)

        [Space(10)]
        [Toggle(COLOR_KEY_ENABLED)]
        _ColorKeyEnabled("Color Key", Float) = 0
        _KeyTex("Key Texture", 2D) = "white" {}

            
        [Space(20)]
        _Grayscale("Grayscale", Range(0, 1)) = 0

        [Space(20)]
        _HueSlider("Hue Slider", Range(0, 1)) = 0

        [Space(20)]
        _Invert("Invert", Range(0, 1)) = 0

        [Space(20)]
        _Contrast("Contrast", Range(-1, 1)) = 0

        [Space(20)]
        [Toggle(SEPIA_ENABLED)]
        _SepiaEnabled("Sepia", Float) = 0

        [Space(20)]
        [Toggle(GRAIN_ENABLED)]
        _FilmGrain("Film Grain", Range(0, 1)) = 0

        [Space(20)]
        [Toggle(OGTV_ENABLED)]
        _OGTVEnabled("Old TV effect", Range(0, 1)) = 0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _KeyTex;
            float4 _KeyTex_ST;

            float _PixelateEnabled;
            float _PixelateAmount = 0;

            float _ColorSwapEnabled;
            float _ColorSwapIntensity;
            float4 _ColorSwap1;
            float4 _ColorSwap2;
            float _ColorKeyEnabled;

            float _Invert;
            float _Grayscale;
            float _HueSlider;
            float _SepiaEnabled;
            float _FilmGrain;
            float _OGTVEnabled;
            float _Contrast;

            // https://github.com/greggman/hsva-unity/blob/dc2f2785896a45a37e7506cc76a772d23f1403ba/Assets/Shaders/HSVRangeShader.shader#L106
            float3 rgb2hsv(float3 c) {
                float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
                float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
                float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

                float d = q.x - min(q.w, q.y);
                float e = 1.0e-10;
                return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
            }

            // https://github.com/greggman/hsva-unity/blob/dc2f2785896a45a37e7506cc76a772d23f1403ba/Assets/Shaders/HSVRangeShader.shader#L116
            float3 hsv2rgb(float3 c) {
                c = float3(c.x, clamp(c.yz, 0.0, 1.0));
                float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
                float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
                return c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
            }

            // https://gist.github.com/keijiro/ee7bc388272548396870
            float nrand(float2 uv)
            {
                return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
            }

            fixed4 pixellate(sampler2D tex, v2f i, float amount) {
                // Adapted from https://github.com/microsoft/DirectX-Graphics-Samples/blob/master/Samples/UWP/D3D12PipelineStateCache/src/PixelatePixelShader.hlsl
                float2 uv = i.uv;
                uint2 var = uint2(uv.x * amount, uv.y * amount);
                uv = float2((float)var.x / amount, (float)var.y / amount);
                i.uv = uv;
                return tex2D(tex, i.uv);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                             
                // Pixellate filter
                if (_PixelateEnabled == 1) {
                    col = pixellate(_MainTex, i, _PixelateAmount);
                }

                // Color swap filter & color key
                if (_ColorSwapEnabled == 1) {
                    // Check to see if pixel color is close to the color specified, and within the margin of the intensity
                    if (abs(col.r - _ColorSwap1.r) < _ColorSwapIntensity 
                        && abs(col.g - _ColorSwap1.g) < _ColorSwapIntensity 
                        && abs(col.b - _ColorSwap1.b) < _ColorSwapIntensity) {

                        if (_ColorKeyEnabled == 1) {
                            // Switch the cam pixel color to the key texture's pixel color.
                            float2 keyuv = i.uv * _KeyTex_ST.xy + _KeyTex_ST.zw;
                            fixed4 keycol = tex2D(_KeyTex, keyuv);
                            col.rgb = keycol.rgb;
                        }
                        else {
                            // Switch the color to the destination color.
                            col.rgb = _ColorSwap2.rgb;
                        }
                    }
                }

                // Hue slider
                float3 hsv = rgb2hsv(col.rgb);
                hsv.r += _HueSlider; // r = hue
                col.rgb = hsv2rgb(hsv);

                // Grayscale
                hsv.g *= 1 - _Grayscale; // g = saturation
                col.rgb = hsv2rgb(hsv);

                // Contrast
                col.rgb = col.rgb * (1 + _Contrast); // F = 259*(255+C)/255*(259-C)

                fixed3 inverted = 1 - col.rgb; // flip colors
                col.rgb = lerp(col.rgb, inverted, _Invert); // make adjustable by lerping the value with the slider's value

                // Sepia
                // tr = 0.393R + 0.769G + 0.189B
                // tg = 0.349R + 0.686G + 0.168B
                // tb = 0.272R + 0.534G + 0.131B
                // https://dyclassroom.com/image-processing-project/how-to-convert-a-color-image-into-sepia-image

                if (_SepiaEnabled == 1) {
                    col.r = 0.393 * col.r + 0.769 * col.g + 0.189 * col.b;
                    col.g = 0.349 * col.r + 0.686 * col.g + 0.168 * col.b;
                    col.b = 0.272 * col.r + 0.534 * col.g + 0.131 * col.b;
                }
                
                if (_FilmGrain == 1) {
                    col.rgb += nrand(i.uv * _SinTime) / 3; // Adding a random value to the pixel base on the uv and _SinTime.
                }

                if (_OGTVEnabled == 1) {
                    col.rgb /= nrand(i.uv / 50 * _SinTime); // warped static effect (white)
                    col.rgb *= nrand(i.uv / 5 * _SinTime); // warped static effect (black)

                    // Color ghost effect
                    float2 offset_uv = i.uv;
                    offset_uv.x -= 0.03;
                    fixed4 offset_col = tex2D(_MainTex, offset_uv);
                    offset_col.rgb -= offset_col.bgr; // make colors weird
                    offset_col.a = 0.4;
                    col.rgb += offset_col;
                }

                return col;
            }


            ENDCG
        }
    }
}
