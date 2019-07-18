#if !defined(MY_LIGHTING_INCLUDED)
#define MY_LIGHTING_INCLUDED

#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

float4 _Tint;
sampler2D _MainTex;
float4 _MainTex_ST;
//float4 _SpecularTint;
float _Metallic;
float _Smoothness;

struct VertexData {
	float4 vertex:POSITION;
	float2 uv : TEXCOORD0;
	float3 normal:NORMAL;
};

struct Interpolators {
	float4 pos:SV_POSITION;
	float2 uv : TEXCOORD0;
	float3 normal:TEXCOORD1;
	float3 worldPos:TEXCOORD2;

	SHADOW_COORDS(3)

#if defined(VERTEXLIGHT_ON)
	float3 vertexLightColor:TEXCOORD4;
#endif
};

void ComputeVertexLightColor(inout Interpolators i) {
#if defined(VERTEXLIGHT_ON)
	i.vertexLightColor = unity_LightColor[0].rgb;
#endif
}

UnityLight CreateLight(Interpolators i) {
	UnityLight light;

#if defined(POINT) || defined(POINT_COOKIE) || defined(SPOT)
	light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
#else
	light.dir = _WorldSpaceLightPos0.xyz;
#endif

	UNITY_LIGHT_ATTENUATION(attenuation, i, i.worldPos);

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
#endif


Interpolators vert(VertexData v) {
	Interpolators i;
	i.pos = UnityObjectToClipPos(v.vertex);
	i.uv = TRANSFORM_TEX(v.uv, _MainTex);
	i.normal = UnityObjectToWorldNormal(v.normal);
	i.worldPos = mul(unity_ObjectToWorld, v.vertex);

	TRANSFER_SHADOW(i);

	ComputeVertexLightColor(i);
	return i;
}

float4 frag(Interpolators i) :SV_TARGET {
	i.normal = normalize(i.normal);
	float3 lightDir = _WorldSpaceLightPos0.xyz;
	float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
	float3 lightColor = _LightColor0.rgb;
	float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
	float3 specularTint;
	float oneMinusReflectivity;
	albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);
	
	float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
	float3 halfVector = normalize(lightDir + viewDir);
	float3 specular = specularTint * lightColor * pow(DotClamped(halfVector, i.normal), _Smoothness * 100);

	return UNITY_BRDF_PBS(albedo, specularTint, oneMinusReflectivity, _Smoothness, i.normal, viewDir, CreateLight(i), CreateIndirectLight(i));
}