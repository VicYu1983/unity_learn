// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MyLighting"
{
	Properties{
		_Tint("Tint", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
		[Gamma]_Metallic("_Metallic", Range(0, 1)) = 0
		_Smoothness("_Smoothness", Range(0, 1)) = .5
	}

	SubShader{
		Pass{
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM

			#pragma target 3.0

			#pragma multi_compile _ SHADOWS_SCREEN
			#pragma	multi_compile _ VERTEXLIGHT_ON

			#pragma vertex vert
			#pragma fragment frag

			#include "MyLighting.cginc"
			
			ENDCG
		}

		Pass{
			Tags{"LightMode" = "ForwardAdd"}

			Blend one one
			ZWrite off

			CGPROGRAM

			#pragma target 3.0

			#pragma multi_compile_fwdadd_fullshadows

			#pragma vertex vert
			#pragma fragment frag

			#include "MyLighting.cginc"

			ENDCG
		}

		Pass{
			Tags{
				"LightMode"="ShadowCaster"
			}

			CGPROGRAM

			#pragma target 3.0

			#pragma multi_compile_shadowcaster

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct VertexData {
				float4 pos:POSITION;
				float3 normal:NORMAL;
			};

#if defined(SHADOWS_CUBE)
			struct Interpolators {
				float4 position : SV_POSITION;
				float3 lightVec : TEXCOORD0;
			};

			Interpolators vert(VertexData v) {
				Interpolators i;
				i.position = UnityObjectToClipPos(v.pos);
				i.lightVec =
					mul(unity_ObjectToWorld, v.pos).xyz - _LightPositionRange.xyz;
				return i;
			}

			float4 frag(Interpolators i) : SV_TARGET {
				float depth = length(i.lightVec) + unity_LightShadowBias.x;
				depth *= _LightPositionRange.w;
				return UnityEncodeCubeShadowDepth(depth);
			}
#else
			
			float4 vert(VertexData v) :SV_POSITION{
				float4 position = UnityClipSpaceShadowCasterPos(v.pos.xyz, v.normal);
				return UnityApplyLinearShadowBias(position);
			}

			half4 frag() : SV_TARGET{ return 0; }

#endif
			ENDCG
		}
	}
}
