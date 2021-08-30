// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Distortion"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_DistortTexture("Displacement Texture", 2D) = "white" {}
		_Magnitude("Magnitude", Range(0,0.5)) = 1
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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				sampler2D _MainTex; //this is the main texture output
				sampler2D _DistortTexture; // this is the texture that is being applied to the output 
				float _Magnitude; // this is how much of the properties the output will have of the overlayed texture

				float4 frag(v2f i) : SV_Target
				{
					float2 disp = tex2D(_DistortTexture, i.uv).xy;
					disp = ((disp * 2) - 1) * _Magnitude;

					float4 col = tex2D(_MainTex, i.uv + disp);
					return col;
				}
				ENDCG
			}
		}
}

// this distortion image effect uses a texture such as a seamless image of grass or something as a source for noise and a 
// uses a slider to regulate how much of the output is affected by the texture of the image you choose. The code works better with seamless 
// textures that have no "watermarks".

