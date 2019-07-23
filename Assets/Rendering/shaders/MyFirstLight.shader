// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/My First Lighting Shader"
{
	Properties{
		_Tint("Tint", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		[NoScaleOffset] _NormalMap("Normals", 2D) = "bump" {}
		_BumpScale("Bump Scale", Float) = 1
		[Gamma] _Metallic("Metallic", Range(0, 1)) = 0
		_Smoothness("Smoothness", Range(0, 1)) = 0.1
		_DetailTex("Detail Texture", 2D) = "gray" {}
		[NoScaleOffset] _DetailNormalMap("Detail Normals", 2D) = "bump" {}
		_DetailBumpScale("Detail Bump Scale", Float) = 1
	}

	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "AutoLight.cginc"
			#include "UnityPBSLighting.cginc"

			float4 _Tint;
			sampler2D _MainTex, _DetailTex;
			float4 _MainTex_ST, _DetailTex_ST;
			float _Metallic;
			float _Smoothness;
			sampler2D _NormalMap, _DetailNormalMap;
			float _BumpScale, _DetailBumpScale;

			struct VertexData {
				float4 pos:POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
			};

			struct Interpolators {
				float4 pos:SV_POSITION;
				float4 uv : TEXCOORD0;
				float3 normal:TEXCOORD1;
				float4 tangent:TEXCOORD2;
				float3 worldPos:TEXCOORD3;

			#if defined(VERTEXLIGHT_ON)
				float3 vertexLightColor:TEXCOORD3;
			#endif
			};

			void ComputeVertexLightColor(inout Interpolators i) {
			#if defined(VERTEXLIGHT_ON)
				i.vertexLightColor = unity_LightColor[0].rgb;
			#endif
			}

			Interpolators vert(VertexData v) {
				Interpolators i;
				i.pos = UnityObjectToClipPos(v.pos);
				i.normal = UnityObjectToWorldNormal(v.normal);
				i.tangent = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);
				i.worldPos = mul(unity_ObjectToWorld, v.pos);
				i.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				i.uv.zw = TRANSFORM_TEX(v.uv, _DetailTex);
				ComputeVertexLightColor(i);
				return i;
			}

			UnityLight CreateLight(Interpolators i) {
				UnityLight light;

			#if defined(POINT) || defined(POINT_COOKIE) || defined(SPOT)
				light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
			#else
				light.dir = _WorldSpaceLightPos0.xyz;
			#endif

				UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
				light.color = _LightColor0.rgb * attenuation;
				light.ndotl = DotClamped(i.normal, light.dir);
				return light;
			}

			UnityIndirect CreateIndirectLight(Interpolators i) {
				UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;

			#if defined(VERTEXLIGHT_ON)
				indirectLight.diffuse = i.vertexLightColor;
			#endif

				return indirectLight;
			}

			void InitializeFragmentNormal(inout Interpolators i) {
				//float2 du = float2(_NormalMap_TexelSize.x * .5, 0);
				//float u1 = tex2D(_NormalMap, i.uv - du);
				//float u2 = tex2D(_NormalMap, i.uv + du);
				//

				//float2 dv = float2(0, _NormalMap_TexelSize.y * .5);
				//float v1 = tex2D(_NormalMap, i.uv - dv);
				//float v2 = tex2D(_NormalMap, i.uv + dv);

				//// same as below
				//// float3 tu = float3(1, u2 - u1, 0);
				//// float3 tv = float3(0, v2 - v1, 1);
				//// i.normal = cross(tv, tu);

				//i.normal = float3(u1 - u2, 1, v1 - v2);
				//i.normal = normalize(i.normal);


				float3 mainNormal = UnpackScaleNormal(tex2D(_NormalMap, i.uv.xy), _BumpScale);
				float3 detailNormal = UnpackScaleNormal(tex2D(_DetailNormalMap, i.uv.zw), _DetailBumpScale);
				float3 tangentSpaceNormal = BlendNormals(mainNormal, detailNormal);
				tangentSpaceNormal = tangentSpaceNormal.xzy;

				float3 binormal = cross(i.normal, i.tangent.xyz) * (i.tangent.w * unity_WorldTransformParams.w);
				i.normal = normalize(
					tangentSpaceNormal.x * i.tangent + 
					tangentSpaceNormal.y * i.normal + 
					tangentSpaceNormal.z * binormal
				);
			}

			float4 frag(Interpolators i):SV_TARGET {
				InitializeFragmentNormal(i);

				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
				float3 lightColor = _LightColor0.rgb;
				float3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Tint.rgb;
				albedo *= tex2D(_DetailTex, i.uv.zw) * unity_ColorSpaceDouble;
				float3 specularTint;
				float oneMinusReflectivity;
				albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);

				float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
				float3 halfVector = normalize(lightDir + viewDir);
				float3 specular = specularTint * lightColor * pow(DotClamped(halfVector, i.normal), _Smoothness * 100);

				//return float4(i.normal, 0);
				return UNITY_BRDF_PBS(albedo, specularTint, oneMinusReflectivity, _Smoothness, i.normal, viewDir, CreateLight(i), CreateIndirectLight(i));
			}

			ENDCG
		}
	}
}
