Shader "Hidden/myShader"

{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DisplacementTexture("displace", 2D) = "white" {}
        _Brightness("brightness", Range(0,3)) = 1
        _Speed("speed", Range(0,5)) = 1
        _Invert("invert", Range(0,1)) = 1
            
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }


            sampler2D _MainTex;
            sampler2D _DisplacementTexture;
            
            float _Invert;
            float _Brightness;
            float _Speed;

            float _height;
            float _width;
            float _shift;
            float _Blur;
            float _displace;

            fixed4 blur(float2 uv) {
                fixed4 average = fixed4(0, 0, 0, 0);

                float2 pixelSize = float2(1.0 / _width, 1.0 / _height);
                
                for (int i = -10; i <= 10; i++) {
                    average += tex2D(_MainTex, uv + pixelSize * i);
                }

                return average / 21.0;
            }

            fixed4 displace(float2 uv) {
            
               // float2 displacement = _displace * float2(sin(_Time.z + uv.y * 10 ), 0.0);

               // float2 displacement = _displace * tex2D(_DisplacementTexture, uv).rg;

                float2 displacement = _displace * float2(SimplexNoise(uv * 5 + _Time.x), SimplexNoise(1234.5 + uv * 5));

                return tex2D(_MainTex, uv + displacement);
            }


            fixed4 frag (v2f i) : SV_Target
            {

                float2 offset = float2(_shift/ _width, 0);

                float colorR = tex2D(_MainTex, i.uv + offset).r;
                float colorG = tex2D(_MainTex, i.uv).g;
                float colorB = tex2D(_MainTex, i.uv - offset).b;

                fixed4 col = fixed4(colorR, colorG, colorB, 1);

                col.rgb = lerp(col.bgr, 1 - col.rgb, _Invert);

                col *= _Brightness;

                //col = lerp(col, blur(i.uv), _Blur);

                col = lerp(col, displace(i.uv), _Blur);

                return col;
            }
            ENDCG
        }
    }
}
