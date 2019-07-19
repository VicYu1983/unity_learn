Shader "Custom/BlobShader" {
	Properties{
		_scale("scale", Range(0, 20000)) = 13000
		_inner("inner", Range(0, 1)) = .5
		_outter("outter", Range(0, 1)) = .1
		_shape("blob shape", Range(0, 10)) = 9
		_fadeEdge("blob edge", Range(0, 1)) = .95
		_waterColor("water color", Color) = (0.3,0.5,0.8)
    }
    SubShader {
        Tags {
            "RenderType"="AlphaTest" "RenderType"="TransparentCutout"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            CGPROGRAM

			#pragma target 3.0	
            #pragma vertex vert
            #pragma fragment frag
            
			#include "UnityCG.cginc"
			
            uniform float4 _point_pos[30];
            uniform float _scale;
            uniform float _inner;
            uniform float _outter;
			uniform float _shape;
			uniform float _fadeEdge;
			uniform int _count;
			uniform float3 _waterColor;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
				float2 extra: TEXCOORD1;
            };

            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv = v.uv;

				// 解決比例問題，防止變形
				o.extra.x = _ScreenParams.x / _ScreenParams.y;
				o.uv.x *= o.extra.x;

                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }

            float getLine( float inner, float outer, float value ){
				float color = smoothstep( inner, outer, value );
				color = color * 2. - 1.;
				color = 1.-abs(color);	
				return color;
			}

            float4 frag(VertexOutput i) : COLOR {

            	float2 uv = i.uv;
            	float4 color_pos = float4(0,0,0,1);
            	for( int j = 0; j < _count; ++j ){

					// 解決比例問題，防止變形。簡單來説就是依照畫面的uv的x軸縮放比例，把傳進來的水滴位置坐標的x軸也等比例縮放就行
					float2 offsetPos = _point_pos[j];
					offsetPos.x *= i.extra.x;

            		float dis = length((float2(uv)-offsetPos));
            		float col = clamp(.5-dis, 0, 1);
					col = pow(col, _shape);
            		color_pos += float4( col, col, col, 1 );
            	}
				color_pos /= _count;

				_inner /= _scale;
				_outter /= _scale;
				_fadeEdge /= _scale;

            	float shape = smoothstep( _inner, _inner + _outter, color_pos.r );
				if (shape <= 0) {
					discard;
				}

            	float shape_inside = smoothstep( _inner, _inner + _fadeEdge, color_pos.r );
            	shape_inside = shape - shape_inside;

                float2 newuv = uv;
                newuv.x += sin((uv.y*13.+_Time*12.)/3.)*.3;
				newuv.x += sin((uv.y*4.+_Time*30)/2.8)*.8;
				newuv.y += sin((uv.x*14.+_Time*60)/3.1)*.31;
				newuv.y += sin((uv.x*3.+_Time*20)/2.3)*.7;

                float wave1 = getLine( .2, .5, newuv.x );
				float wave2 = getLine( .2, .7, newuv.y );
				float wave3 = getLine( .2, .21, newuv.x - newuv.y );
				float wave4 = getLine( .2, .23, newuv.x * newuv.y );
				float wave5 = getLine( .2, .25, newuv.x / newuv.y );
				float allwave = wave1 + wave2 + wave3 + wave4 + wave5;

				float3 outcolor = lerp(_waterColor, float3(1,1,1), allwave );
				outcolor = lerp( float3(0.3,0.3,0.3), outcolor, shape );
				outcolor += shape_inside / 1.5;

                return fixed4(outcolor, 0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
