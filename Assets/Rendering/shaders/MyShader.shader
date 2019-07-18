// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MyShader"
{
	Properties{
		_Tint("Tint", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
	}

	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct Interpolocators {
				float4 pos:SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			struct VertexData {
				float4 pos:POSITION;
				float2 uv : TEXCOORD0;
			};

			Interpolocators vert(VertexData v){
				Interpolocators i;
				i.pos = UnityObjectToClipPos(v.pos);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return i;
			}

			float4 frag(Interpolocators i):SV_TARGET {
				return tex2D(_MainTex, i.uv) * _Tint;
			}

			ENDCG
		}
	}
}
