// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/GrayScale"
{
        Properties{
            _MainTex("Texture", 2D) = "white" { }
        }
        SubShader
        {
            Pass {

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"

                sampler2D _MainTex;

                struct v2f {
                    float4  pos : SV_POSITION;
                    float2  uv : TEXCOORD0;
                };

                float4 _MainTex_ST;

                v2f vert(appdata_base v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                    return o;
                }

                half4 frag(v2f i) : COLOR
                {
                    half4 texcol = tex2D(_MainTex, i.uv);
                    texcol.rgb = dot(texcol.rgb, float3(0.3, 0.59, 0.11));
                    return texcol;
                }
                ENDCG

            }
        }
        Fallback "VertexLit"
}

// this code is a way to grayscale the output by using the dot product
// the grayscale is pretty consistent even with the presence of a lot of light. Can still be affected by contrast, brightness, and inversion

