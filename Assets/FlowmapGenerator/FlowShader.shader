Shader "Unlit/FlowShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DiffuseTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="ForwardBase" }
        LOD 100

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

            sampler2D _MainTex, _DiffuseTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 flowMap = tex2D(_MainTex, i.uv);
				flowMap.rg = flowMap.rg * 2 - 1;
				flowMap.rg *= .1;
				flowMap.rg += i.uv;
				
				float time1 = _Time.y;
				float time2 = time1 + .5;
				float2 lerpUV = lerp(i.uv, flowMap.rg, frac(time1));
				float2 lerpUV2 = lerp(i.uv, flowMap.rg, frac(time2));

				fixed4 map = tex2D(_DiffuseTex, lerpUV);
				fixed4 toMap = tex2D(_DiffuseTex, lerpUV2);

				map *= 1 - abs(frac(time1) - .5) * 2;
				toMap *= 1 - abs(frac(time2) - .5) * 2;

				return map + toMap;
            }
            ENDCG
        }
    }
}
