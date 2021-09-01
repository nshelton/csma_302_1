Shader "Hidden/myShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Invert ("invert", Range(0,1)) = 1
        _Brightness("brightness", Range(0,3)) = 1
        _Speed("speed", Range(0,3)) = 1
        _Contrast("constrast", Range(0,1)) = 1
        _Tint("tint", Color) = (1,1,1,1)
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
            #include "Packages/jp.keijiro.noiseshader/Shader/SimplexNoise2D.hlsl"

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

            half4 _Tint;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Invert;
            float _Brightness;
            float _Speed;
            float _width;
            float _height;
            float _Contrast;
            float _Grain;



            fixed4 blur(float2 uv) {
                fixed4 average = fixed4(0, 0, 0, 0);

                float2 offset = float2(1.0 / _width, 1.0 / _height);

                for (int i = -5; i <= 5; i++) {
                    average += tex2D(_MainTex, uv + offset * i);
                }

                return average / 11.0;
            }




            fixed4 frag (v2f i) : SV_Target
            {
                float2 offset = float2(20.0 / _width, 0);

                float colorR = tex2D(_MainTex, i.uv + offset).r;
                float colorG = tex2D(_MainTex, i.uv).g;
                float colorB = tex2D(_MainTex, i.uv - offset).b;

                fixed4 col = fixed4(colorR, colorG, colorB, 1);
                //col = col + col2;

                // just invert the colors
                
                col.rgb = lerp(col.rgb, 1 - col.rgb, _Invert);

                //col *= _Tint;

                //col *= _Brightness;
                //col *= ((sin(_Time.z) + 1) / 2) * _Speed;

                col.rgb += float3(SimplexNoise(i.uv * 15), SimplexNoise(i.uv * 15 + 999.9), SimplexNoise(i.uv * 15 + 124.5)) * _Grain;

                return col;
            }
            ENDCG
        }
    }
}
