Shader "Custom/Detail"
{
	Properties{
		_MainTex("Texture", 2D) = "white" {}
		[NoScaleOffset]_T1("Texture", 2D) = "white" {}
		[NoScaleOffset]_T2("Texture", 2D) = "white" {}
		[NoScaleOffset]_T3("Texture", 2D) = "white" {}
		[NoScaleOffset]_T4("Texture", 2D) = "white" {}
	}

	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _T1, _T2, _T3, _T4;

			struct Interpolocators {
				float4 pos:SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uvSplat : TEXCOORD1;
			};

			struct VertexData {
				float4 pos:POSITION;
				float2 uv : TEXCOORD0;
			};

			Interpolocators vert(VertexData v) {
				Interpolocators i;
				i.pos = UnityObjectToClipPos(v.pos);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.uvSplat = v.uv;
				return i;
			}

			float4 frag(Interpolocators i) :SV_TARGET {
				float4 splat = tex2D(_MainTex, i.uvSplat);
			return
				tex2D(_T1, i.uv) * splat.r +
				tex2D(_T2, i.uv) * splat.g +
				tex2D(_T3, i.uv) * splat.b +
				tex2D(_T4, i.uv) * (1 - splat.r - splat.g - splat.g);
			}

			ENDCG
		}
	}
}
