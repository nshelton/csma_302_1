Shader "Hidden/shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint ("Tint Color", Color) = (1, 1, 1, 1)
        _Invert ("invert", Range(0,1)) = 0
        _Brightness ("brightness", Range(0,1)) = 1
        _Contrast ("contrast", Range(0,4)) = 1
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
            float _Invert;
            float _Brightness;
            float _Contrast;

            float _width;
            float _height;

            float4 _Greyscale;
            float4 _Tint;


            // from professor Shelton's lecture
            fixed4 blur(float2 uv) {

                fixed4 average = fixed4(0, 0, 0, 0);

                float2 offset = float2(1.0 / _width, 0);
                
                for (int i = -5; i <= 5; i++) {
                    average += tex2D(_MainTex, uv + offset * i);
                }

                return average / 11.0;
            }


            // from professor Shelton's lecture
            fixed4 color_shift(float2 uv){

                float2 offset = float2(20.0 / _width, 0);

                float colorR = tex2D(_MainTex, uv + offset).r;
                float colorG = tex2D(_MainTex, uv).g;
                float colorB = tex2D(_MainTex, uv - offset).b;

                fixed4 shift = fixed4(colorR, colorG, colorB, 1);

                return shift;

            }


            float4 tint_img(){

                return _Tint;

            }

            float4 greyscale(){
                
                // calculate grey vector magnitudes
                _Greyscale = (0.8, 1.6, 0.3);

                return _Greyscale;
            }
            
       
            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);

                // swizzling (accessing color channels in a different order)
                // col = col.gbra;

                // color shifting
                // col.rgb += color_shift(i.uv);

                // blur
                // col.rgb += blur(i.uv);

                // use for chroma tinting, can be changed via inspector
                // fixed4 col = tex2D(_MainTex, i.uv) + tint_img();

                // displace xy coords based on x-axis, then shift based on time
                // fixed4 col = tex2D(_MainTex, i.uv + float2(0, sin(i.vertex.x/50 + _Time[1]) / 40));

                // displace xy coords based on y-axis, then shift based on time * 2
                // fixed4 col = tex2D(_MainTex, i.uv + float2(sin(i.vertex.y/50 + _Time[2]) / 20, 0));

                // invert the colors via inspector
                //col.rgb = lerp(col.rgb, 1 - col.rgb, _Invert);

                // apply greyscale
                // col.rgb = dot(col.rgb, greyscale());

                // adjust contrast via inspector
                //col.rgb = ((col.rgb - 0.5f) * max(_Contrast, 0)) + 0.5f;

                // adjust brightness via inspector
                //col *= _Brightness;
                

                return col;
            }
            ENDCG
        }
    }
}
