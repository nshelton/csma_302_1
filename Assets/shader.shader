Shader "Hidden/shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint ("Tint Color", Color) = (1, 1, 1, 1)
        _Colorshift ("Color Shift", Range(0,20)) = 0
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
            float _Colorshift;
            float _Blur;
            float _displaceY;
            float _displaceX;
            float _GreyscaleActive;
            float _ApplyTint;
            float _Swizzle;
            float _width;
            float _height;

            float3 _GreyscaleVector;
            float4 _Tint;


            // from professor Shelton's lecture
            fixed4 blur(float2 uv) {

                fixed4 average = fixed4(0, 0, 0, 0);

                float2 offset = float2(1.0 / _width, 0);
                
                for (int i = -15; i <= 15; i++) {
                    average += tex2D(_MainTex, uv + offset * i);
                }

                return average / 31.0;
            }


            // from professor Shelton's lecture
            fixed4 color_shift(float2 uv){

                float2 offset = float2(_Colorshift / _width, 0);

                float colorR = tex2D(_MainTex, uv + offset).r;
                float colorG = tex2D(_MainTex, uv).g;
                float colorB = tex2D(_MainTex, uv - offset).b;

                fixed4 shift = fixed4(colorR, colorG, colorB, 1);

                return shift;

            }


            float3 greyscale(){
                
                // calculate grey vector magnitudes; I just looked up what type of grey I wanted :P
                _GreyscaleVector = (0.8, 1.6, 0.3);

                return _GreyscaleVector;
            }
            
       
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                // swizzling (accessing color channels in a different order)
                if(_Swizzle >= 1 && _Swizzle < 2)
                    col = col.gbra;
                else if(_Swizzle == 2)
                    col = col.brga;

                // color shifting
                if(_Colorshift > 0)
                    col = color_shift(i.uv);

                // blur
                if(_Blur > 0)
                    col = lerp(col, blur(i.uv), _Blur);

                // use for chroma tinting, can be changed via inspector
                // make sure _ApplyTint is at 1 in inspector to apply tint (b/c bools don't exist with shaders -_- )
                if(_ApplyTint == 1)
                    col = tex2D(_MainTex, i.uv) + _Tint;

                // displace xy coords based on x-axis, then shift based on time
                if(_displaceY > 0)
                    col = tex2D(_MainTex, i.uv + float2(0, sin(i.vertex.x/50 + _Time[1]) / _displaceY));

                // displace xy coords based on y-axis, then shift based on time * 2
                if(_displaceX > 0)
                    col = tex2D(_MainTex, i.uv + float2(sin(i.vertex.y/50 + _Time[2]) / _displaceX, 0));

                // invert the colors via inspector
                if(_Invert >= 0)
                    col.rgb = lerp(col.rgb, 1 - col.rgb, _Invert);                

                // apply greyscale
                // make sure _GreyscaleActive is a 1 in inspector to apply greyscale (b/c bools don't exist with shaders -_- )
                if(_GreyscaleActive == 1)
                    col.rgb = dot(col.rgb, greyscale());
                
                // adjust contrast via inspector
                // contrast equation derived from this explanation and sample code: http://redqueengraphics.com/2018/07/29/metal-shaders-color-adjustments/
                if(_Contrast > 0)
                    col.rgb = ((col.rgb - 0.5f) * max(_Contrast, 0)) + 0.5f;

                // adjust brightness via inspector
                if(_Brightness >= 1)
                    col *= _Brightness;
                

                return col;
            }
            ENDCG
        }
    }
}
