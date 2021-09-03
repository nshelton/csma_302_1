Shader "cameraEffects"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
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
            float _Height;
            float _Width;
            float _Brightness;
            float _Invert;
            float _Blur;
            float _RedOverlay;
            float _Grayscale;
            float _Noise;
            float _Shift;
            float _Displace;
            float _Perspective;
            float _CamTransition;

            fixed4 blur(float2 uv) {
                fixed4 average = fixed4(0, 0, 0, 0);
                float2 offset = float2(1.0 / _Width, 0);

                for (int i = -5; i <= 5; i++) {
                    average += tex2D(_MainTex, uv + offset * i);
                }

                return average / 11.0;
            }

            fixed4 redOverlay(fixed4 color) {
                float b = color.b;
                return fixed4(1, b, b, 1);
            }

            fixed4 grayscale(fixed4 color) {
                float b = color;
                return fixed4(b, b, b, 1);
            }

            fixed4 noise(float2 uv) {
                float2 grain = _Noise * float4(1, 1, 0, 1);
                return tex2D(_MainTex, uv + grain);
            }

            fixed4 shift(float2 uv) {
                float2 offset = float2(_Shift / _Width, 0);
                float colorR = tex2D(_MainTex, uv + offset).r;
                float colorG = tex2D(_MainTex, uv).g;
                float colorB = tex2D(_MainTex, uv - offset).b;
                fixed4 colorShift = fixed4(colorR, colorG, colorB, 1);
                return colorShift;
            }

            fixed4 displace(float2 uv) {
                float2 displacement = _Displace * float2(sin(_Time.z + uv.y * 10 ), 0.0);
                return tex2D(_MainTex, uv + displacement);
            }

            fixed4 perspective(float2 uv) {
                fixed4 fixedVal = fixed4(0, 0, 0, 0);
                float2 offset = float2(1.0 / _Width - 0.2, 0);

                for (int i = -5; i <= 5; i++) {
                    fixedVal += tex2D(_MainTex, i * uv + offset);
                }

                return fixedVal / 19.0;
            }

            fixed4 camTransition(float2 uv) {
                float2 transition = _CamTransition * float2(tan(_Time.z + uv.x * 0.3), 0.0);
                return tex2D(_MainTex, uv + transition);
            }

            fixed4 frag(v2f i) : SV_Target
            {
               fixed4 col = tex2D (_MainTex, i.uv);

                col *= _Brightness;
                col = lerp(col, 1 - col, _Invert);
                col = lerp(col, blur(i.uv), _Blur);
                col = lerp(col, redOverlay(col), _RedOverlay);
                col = lerp(col, grayscale(col), _Grayscale);
                col = lerp(col, noise(col), _Noise);
                col = lerp(col, shift(i.uv), _Shift);
                col = lerp(col, displace(i.uv), _Displace);
                col = lerp(col, perspective(i.uv), _Perspective);
                col = lerp(col, camTransition(i.uv), _CamTransition);

                return col;
            }

            ENDCG
        }
    }
}
