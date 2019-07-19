Shader "Unlit/myPostEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_power("power", Range(0, .1)) = .01
		_speed("speed", Range(1, 1000)) = 10
		_distance("distance", Range(1, 100)) = 3
	}
	SubShader
	{
		Tags { "RenderType" = "Forward" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _dropPos;
			float _power;
			float _speed;
			int _distance;
			float _effect;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 uv : TEXCOORD0;
				float4 dropPos: TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.uv;
				o.uv.z = _ScreenParams.x / _ScreenParams.y;
				o.dropPos = _dropPos;
				o.dropPos.x *= o.uv.z;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float2 newuv = i.uv.xy;
				newuv.x *= i.uv.z;

				float pos_color = clamp(1 - length(newuv - i.dropPos), 0, 1);
				float flowMap = sin(pos_color * _distance + _Time * _speed) * pow(pos_color, 6) * _power;

				flowMap *= _effect;

				i.uv += flowMap;
				fixed4 col = tex2D(_MainTex, i.uv);

				return col;
            }
            ENDCG
        }
    }
}
