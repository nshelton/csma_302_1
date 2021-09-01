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

            float _kernel[9];

           // float kernel[5] = { 0.06136,	    0.24477,	0.38774,	0.24477,	0.06136 };
           // float kernel[5] = {0.2, 0.2, 0.2, 0.2, 0.2};


            fixed4 kernel3x3(float2 uv) {
                fixed4 sum = fixed4(0, 0, 0, 0);

                float2 pixelSizeX = float2(1.0 / _width, 0);
                float2 pixelSizeY = float2(0, 1.0 / _height);

                int index = 0;

                for (int i = -1; i <= 1; i++) {
                    for (int j = -1; j <= 1; j++) {
                        sum += _kernel[index] * tex2D(_MainTex, uv + pixelSizeX * i + pixelSizeY * j);
                        index++;
                    }
                }

                return sum;
            }


            fixed4 blurH(float2 uv) {
                fixed4 sum = fixed4(0, 0, 0, 0);

                float2 pixelSize = float2(1.0 / _width, 0);
                
                for (int i = -1; i <= 1; i++) {
                    sum += _kernel[i + 1] * tex2D(_MainTex, uv + pixelSize * i);
                }

                return sum;
            }

            fixed4 blurV(float2 uv) {
                fixed4 sum = fixed4(0, 0, 0, 0);

                float2 pixelSize = float2(0, 1.0 / _height);

                for (int i = -1; i <= 1; i++) {
                    sum += _kernel[i + 1] * tex2D(_MainTex, uv + pixelSize * i);
                }

                return sum;
            }

            fixed4 displace(float2 uv) {
            
               // float2 displacement = _displace * float2(sin(_Time.z + uv.y * 10 ), 0.0);

               // float2 displacement = _displace * tex2D(_DisplacementTexture, uv).rg;

                float2 displacement = _displace * float2(SimplexNoise(uv * 5 + _Time.x), SimplexNoise(1234.5 + uv * 5));

                return tex2D(_MainTex, uv + displacement);
            }


            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 col = tex2D(_MainTex, i.uv);

                //col = lerp(col, blurH(i.uv), _Blur);
                //col = lerp(col, blurV(i.uv), _Blur);

                col = lerp(col, kernel3x3(i.uv), _Blur);

                col *= _Brightness;

                return col;
            }
            ENDCG
        }
    }
}
