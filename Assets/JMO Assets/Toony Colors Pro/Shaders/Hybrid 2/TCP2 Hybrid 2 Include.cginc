﻿// Toony Colors Pro+Mobile 2
// (c) 2014-2023 Jean Moreno

/// #define fixed half
/// #define fixed2 half2
/// #define fixed3 half3
/// #define fixed4 half4

// Built-in renderer (CG) to SRP (HLSL) bindings
#if defined(TCP2_HYBRID_URP)
	#define UnityObjectToClipPos TransformObjectToHClip
	#define UnityObjectToWorldNormal TransformObjectToWorldNormal
	#define _WorldSpaceLightPos0 _MainLightPosition
	#define UnpackScaleNormal UnpackNormalScale
#else
	// URP to BIRP
	#define CopySign(x,s) ((s >= 0) ? abs(x) : -abs(x))
	#define UNITY_MATRIX_I_M unity_WorldToObject
#endif

#if defined(TCP2_HYBRID_URP)

	#ifndef URP_VERSION
		#error URP version undefined
	#endif

	// #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	// This would cause a compilation error if URP isn't installed, so instead we use the dedicated
	// "URP Support" file which contains all needed .hlslinc files embedded within a single file.
	// #include "TCP2 Hybrid URP Support.cginc"

	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
	#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
	#if URP_VERSION >= 12
		#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
	#endif

	#define UNITY_PASS_FORWARDBASE
#endif

#if defined(TCP2_HYBRID_URP) && URP_VERSION >= 14
	#define IS_LIGHTING_FEATURE_ENABLED(feature)	if (IsLightingFeatureEnabled(feature))
#else
	#define IS_LIGHTING_FEATURE_ENABLED(feature)
#endif

#if defined(LOD_FADE_CROSSFADE)
	static const float DITHER_THRESHOLDS_4x4[16] =
	{
		0.0588, 0.5294, 0.1765, 0.6471,
		0.7647, 0.2941, 0.8823, 0.4118,
		0.2353, 0.7059, 0.1176, 0.5882,
		0.9412, 0.4706, 0.8235, 0.3529
	};
	float Dither4x4(float2 positionCS)
	{
		#if SHADER_API_GLES // gles 2.0
			float index = (floor(positionCS.x) % 4.0) * 4.0 + (floor(positionCS.y) % 4.0);
		#else
			uint index = (uint(positionCS.x) % 4u) * 4u + uint(positionCS.y) % 4u;
		#endif
		return DITHER_THRESHOLDS_4x4[index];
	}
#endif

//================================================================================================================================
//================================================================================================================================

// MAIN

//================================================================================================================================
//================================================================================================================================

// Uniforms
CBUFFER_START(UnityPerMaterial)
	half _RampSmoothing;
	half _RampThreshold;
	half _RampBands;
	half _RampBandsSmoothing;
	half _RampScale;
	half _RampOffset;

	float4 _BumpMap_ST;
	half _BumpScale;

	float4 _BaseMap_ST;

	half _Cutoff;

	half4 _BaseColor;

	float4 _EmissionMap_ST;
	half _EmissionChannel;
	half4 _EmissionColor;

	half4 _MatCapColor;
	half _MatCapMaskChannel;
	half _MatCapType;

	half4 _SColor;
	half4 _HColor;

	half _RimMin;
	half _RimMax;
	half4 _RimColor;

	half _SpecularRoughness;
	half4 _SpecularColor;
	half _SpecularMapType;
	half _SpecularToonSize;
	half _SpecularToonSmoothness;

	half _ReflectionSmoothness;
	half4 _ReflectionColor;
	half _FresnelMax;
	half _FresnelMin;
	half _ReflectionMapType;

	half _OcclusionStrength;
	half _OcclusionChannel;

	half _IndirectIntensity;
	half _SingleIndirectColor;

	half _OutlineWidth;
	half _OutlineMinWidth;
	half _OutlineMaxWidth;
	half4 _OutlineColor;
	half _OutlineTextureLOD;
	half _DirectIntensityOutline;
	half _IndirectIntensityOutline;
CBUFFER_END

#if URP_VERSION >= 14 && defined(UNITY_DOTS_INSTANCING_ENABLED)

// --------------------------------
// DOTS INSTANCING & BRG SUPPORT

UNITY_DOTS_INSTANCING_START(UserPropertyMetadata)
	UNITY_DOTS_INSTANCED_PROP(float, _RampSmoothing)
	UNITY_DOTS_INSTANCED_PROP(float, _RampThreshold)
	UNITY_DOTS_INSTANCED_PROP(float, _RampBands)
	UNITY_DOTS_INSTANCED_PROP(float, _RampBandsSmoothing)
	UNITY_DOTS_INSTANCED_PROP(float, _RampScale)
	UNITY_DOTS_INSTANCED_PROP(float, _RampOffset)

	UNITY_DOTS_INSTANCED_PROP(float, _BumpScale)

	UNITY_DOTS_INSTANCED_PROP(float, _Cutoff)

	UNITY_DOTS_INSTANCED_PROP(float4, _BaseColor)

	UNITY_DOTS_INSTANCED_PROP(float, _EmissionChannel)
	UNITY_DOTS_INSTANCED_PROP(float4, _EmissionColor)

	UNITY_DOTS_INSTANCED_PROP(float4, _MatCapColor)
	UNITY_DOTS_INSTANCED_PROP(float, _MatCapMaskChannel)
	UNITY_DOTS_INSTANCED_PROP(float, _MatCapType)

	UNITY_DOTS_INSTANCED_PROP(float4, _SColor)
	UNITY_DOTS_INSTANCED_PROP(float4, _HColor)

	UNITY_DOTS_INSTANCED_PROP(float, _RimMin)
	UNITY_DOTS_INSTANCED_PROP(float, _RimMax)
	UNITY_DOTS_INSTANCED_PROP(float4, _RimColor)

	UNITY_DOTS_INSTANCED_PROP(float, _SpecularRoughness)
	UNITY_DOTS_INSTANCED_PROP(float4, _SpecularColor)
	UNITY_DOTS_INSTANCED_PROP(float, _SpecularMapType)
	UNITY_DOTS_INSTANCED_PROP(float, _SpecularToonSize)
	UNITY_DOTS_INSTANCED_PROP(float, _SpecularToonSmoothness)

	UNITY_DOTS_INSTANCED_PROP(float, _ReflectionSmoothness)
	UNITY_DOTS_INSTANCED_PROP(float4, _ReflectionColor)
	UNITY_DOTS_INSTANCED_PROP(float, _FresnelMax)
	UNITY_DOTS_INSTANCED_PROP(float, _FresnelMin)
	UNITY_DOTS_INSTANCED_PROP(float, _ReflectionMapType)

	UNITY_DOTS_INSTANCED_PROP(float, _OcclusionStrength)
	UNITY_DOTS_INSTANCED_PROP(float, _OcclusionChannel)

	UNITY_DOTS_INSTANCED_PROP(float, _IndirectIntensity)
	UNITY_DOTS_INSTANCED_PROP(float, _SingleIndirectColor)

	UNITY_DOTS_INSTANCED_PROP(float, _OutlineWidth)
	UNITY_DOTS_INSTANCED_PROP(float, _OutlineMinWidth)
	UNITY_DOTS_INSTANCED_PROP(float, _OutlineMaxWidth)
	UNITY_DOTS_INSTANCED_PROP(float4, _OutlineColor)
	UNITY_DOTS_INSTANCED_PROP(float, _OutlineTextureLOD)
	UNITY_DOTS_INSTANCED_PROP(float, _DirectIntensityOutline)
	UNITY_DOTS_INSTANCED_PROP(float, _IndirectIntensityOutline)
UNITY_DOTS_INSTANCING_END(UserPropertyMetadata)

// --------

// See URP's LitInput.hlsl for why we use static variables
static float unity_DOTS_Sampled_RampSmoothing;
static float unity_DOTS_Sampled_RampThreshold;
static float unity_DOTS_Sampled_RampBands;
static float unity_DOTS_Sampled_RampBandsSmoothing;
static float unity_DOTS_Sampled_RampScale;
static float unity_DOTS_Sampled_RampOffset;
static float unity_DOTS_Sampled_BumpScale;
static float unity_DOTS_Sampled_Cutoff;
static float4 unity_DOTS_Sampled_BaseColor;
static float unity_DOTS_Sampled_EmissionChannel;
static float4 unity_DOTS_Sampled_EmissionColor;
static float4 unity_DOTS_Sampled_MatCapColor;
static float unity_DOTS_Sampled_MatCapMaskChannel;
static float unity_DOTS_Sampled_MatCapType;
static float4 unity_DOTS_Sampled_SColor;
static float4 unity_DOTS_Sampled_HColor;
static float unity_DOTS_Sampled_RimMin;
static float unity_DOTS_Sampled_RimMax;
static float4 unity_DOTS_Sampled_RimColor;
static float unity_DOTS_Sampled_SpecularRoughness;
static float4 unity_DOTS_Sampled_SpecularColor;
static float unity_DOTS_Sampled_SpecularMapType;
static float unity_DOTS_Sampled_SpecularToonSize;
static float unity_DOTS_Sampled_SpecularToonSmoothness;
static float unity_DOTS_Sampled_ReflectionSmoothness;
static float4 unity_DOTS_Sampled_ReflectionColor;
static float unity_DOTS_Sampled_FresnelMax;
static float unity_DOTS_Sampled_FresnelMin;
static float unity_DOTS_Sampled_ReflectionMapType;
static float unity_DOTS_Sampled_OcclusionStrength;
static float unity_DOTS_Sampled_OcclusionChannel;
static float unity_DOTS_Sampled_IndirectIntensity;
static float unity_DOTS_Sampled_SingleIndirectColor;
static float unity_DOTS_Sampled_OutlineWidth;
static float unity_DOTS_Sampled_OutlineMinWidth;
static float unity_DOTS_Sampled_OutlineMaxWidth;
static float4 unity_DOTS_Sampled_OutlineColor;
static float unity_DOTS_Sampled_OutlineTextureLOD;
static float unity_DOTS_Sampled_DirectIntensityOutline;
static float unity_DOTS_Sampled_IndirectIntensityOutline;

// --------

void SetupDOTSTcp2PropertyCaches()
{
	unity_DOTS_Sampled_RampSmoothing = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _RampSmoothing);
	unity_DOTS_Sampled_RampThreshold = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _RampThreshold);
	unity_DOTS_Sampled_RampBands = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _RampBands);
	unity_DOTS_Sampled_RampBandsSmoothing = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _RampBandsSmoothing);
	unity_DOTS_Sampled_RampScale = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _RampScale);
	unity_DOTS_Sampled_RampOffset = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _RampOffset);
	// unity_DOTS_Sampled_BumpMap_ST = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _BumpMap_ST);
	unity_DOTS_Sampled_BumpScale = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _BumpScale);
	// unity_DOTS_Sampled_BaseMap_ST = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _BaseMap_ST);
	unity_DOTS_Sampled_Cutoff = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _Cutoff);
	unity_DOTS_Sampled_BaseColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _BaseColor);
	// unity_DOTS_Sampled_EmissionMap_ST = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _EmissionMap_ST);
	unity_DOTS_Sampled_EmissionChannel = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _EmissionChannel);
	unity_DOTS_Sampled_EmissionColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _EmissionColor);
	unity_DOTS_Sampled_MatCapColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _MatCapColor);
	unity_DOTS_Sampled_MatCapMaskChannel = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _MatCapMaskChannel);
	unity_DOTS_Sampled_MatCapType = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _MatCapType);
	unity_DOTS_Sampled_SColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _SColor);
	unity_DOTS_Sampled_HColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _HColor);
	unity_DOTS_Sampled_RimMin = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _RimMin);
	unity_DOTS_Sampled_RimMax = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _RimMax);
	unity_DOTS_Sampled_RimColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _RimColor);
	unity_DOTS_Sampled_SpecularRoughness = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _SpecularRoughness);
	unity_DOTS_Sampled_SpecularColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _SpecularColor);
	unity_DOTS_Sampled_SpecularMapType = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _SpecularMapType);
	unity_DOTS_Sampled_SpecularToonSize = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _SpecularToonSize);
	unity_DOTS_Sampled_SpecularToonSmoothness = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _SpecularToonSmoothness);
	unity_DOTS_Sampled_ReflectionSmoothness = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _ReflectionSmoothness);
	unity_DOTS_Sampled_ReflectionColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _ReflectionColor);
	unity_DOTS_Sampled_FresnelMax = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _FresnelMax);
	unity_DOTS_Sampled_FresnelMin = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _FresnelMin);
	unity_DOTS_Sampled_ReflectionMapType = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _ReflectionMapType);
	unity_DOTS_Sampled_OcclusionStrength = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _OcclusionStrength);
	unity_DOTS_Sampled_OcclusionChannel = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _OcclusionChannel);
	unity_DOTS_Sampled_IndirectIntensity = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _IndirectIntensity);
	unity_DOTS_Sampled_SingleIndirectColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _SingleIndirectColor);
	unity_DOTS_Sampled_OutlineWidth = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _OutlineWidth);
	unity_DOTS_Sampled_OutlineMinWidth = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _OutlineMinWidth);
	unity_DOTS_Sampled_OutlineMaxWidth = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _OutlineMaxWidth);
	unity_DOTS_Sampled_OutlineColor = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float4 , _OutlineColor);
	unity_DOTS_Sampled_OutlineTextureLOD = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _OutlineTextureLOD);
	unity_DOTS_Sampled_DirectIntensityOutline = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _DirectIntensityOutline);
	unity_DOTS_Sampled_IndirectIntensityOutline = UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT (float  , _IndirectIntensityOutline);
}

#undef UNITY_SETUP_DOTS_MATERIAL_PROPERTY_CACHES
#define UNITY_SETUP_DOTS_MATERIAL_PROPERTY_CACHES() SetupDOTSTcp2PropertyCaches()

#define _RampSmoothing 				unity_DOTS_Sampled_RampSmoothing
#define _RampThreshold 				unity_DOTS_Sampled_RampThreshold
#define _RampBands 					unity_DOTS_Sampled_RampBands
#define _RampBandsSmoothing 		unity_DOTS_Sampled_RampBandsSmoothing
#define _RampScale 					unity_DOTS_Sampled_RampScale
#define _RampOffset 				unity_DOTS_Sampled_RampOffset
#define _BumpScale 					unity_DOTS_Sampled_BumpScale
#define _Cutoff 					unity_DOTS_Sampled_Cutoff
#define _BaseColor 					unity_DOTS_Sampled_BaseColor
#define _EmissionChannel 			unity_DOTS_Sampled_EmissionChannel
#define _EmissionColor 				unity_DOTS_Sampled_EmissionColor
#define _MatCapColor 				unity_DOTS_Sampled_MatCapColor
#define _MatCapMaskChannel 			unity_DOTS_Sampled_MatCapMaskChannel
#define _MatCapType 				unity_DOTS_Sampled_MatCapType
#define _SColor 					unity_DOTS_Sampled_SColor
#define _HColor 					unity_DOTS_Sampled_HColor
#define _RimMin 					unity_DOTS_Sampled_RimMin
#define _RimMax 					unity_DOTS_Sampled_RimMax
#define _RimColor 					unity_DOTS_Sampled_RimColor
#define _SpecularRoughness 			unity_DOTS_Sampled_SpecularRoughness
#define _SpecularColor 				unity_DOTS_Sampled_SpecularColor
#define _SpecularMapType 			unity_DOTS_Sampled_SpecularMapType
#define _SpecularToonSize 			unity_DOTS_Sampled_SpecularToonSize
#define _SpecularToonSmoothness 	unity_DOTS_Sampled_SpecularToonSmoothness
#define _ReflectionSmoothness 		unity_DOTS_Sampled_ReflectionSmoothness
#define _ReflectionColor 			unity_DOTS_Sampled_ReflectionColor
#define _FresnelMax 				unity_DOTS_Sampled_FresnelMax
#define _FresnelMin 				unity_DOTS_Sampled_FresnelMin
#define _ReflectionMapType 			unity_DOTS_Sampled_ReflectionMapType
#define _OcclusionStrength 			unity_DOTS_Sampled_OcclusionStrength
#define _OcclusionChannel 			unity_DOTS_Sampled_OcclusionChannel
#define _IndirectIntensity 			unity_DOTS_Sampled_IndirectIntensity
#define _SingleIndirectColor 		unity_DOTS_Sampled_SingleIndirectColor
#define _OutlineWidth 				unity_DOTS_Sampled_OutlineWidth
#define _OutlineMinWidth 			unity_DOTS_Sampled_OutlineMinWidth
#define _OutlineMaxWidth 			unity_DOTS_Sampled_OutlineMaxWidth
#define _OutlineColor 				unity_DOTS_Sampled_OutlineColor
#define _OutlineTextureLOD 			unity_DOTS_Sampled_OutlineTextureLOD
#define _DirectIntensityOutline 	unity_DOTS_Sampled_DirectIntensityOutline
#define _IndirectIntensityOutline 	unity_DOTS_Sampled_IndirectIntensityOutline

// --------------------------------

#endif

// Samplers
sampler2D _BaseMap;
sampler2D _Ramp;
sampler2D _BumpMap;
sampler2D _EmissionMap;
sampler2D _OcclusionMap;
sampler2D _ReflectionTex;
sampler2D _SpecGlossMap;
sampler2D _ShadowBaseMap;
sampler2D _MatCapTex;
sampler2D _MatCapMask;

// Meta Pass
#if defined(UNITY_PASS_META) && !defined(TCP2_HYBRID_URP)
	#include "UnityMetaPass.cginc"
#endif

//Specular help functions (from UnityStandardBRDF.cginc)
inline float3 TCP2_SafeNormalize(float3 inVec)
{
	half dp3 = max(0.001f, dot(inVec, inVec));
	return inVec * rsqrt(dp3);
}

//GGX
#define TCP2_PI 3.14159265359
#define TCP2_INV_PI 0.31830988618f
#if defined(SHADER_API_MOBILE)
	#define TCP2_EPSILON 1e-4f
#else
	#define TCP2_EPSILON 1e-7f
#endif
inline half GGX(half NdotH, half roughness)
{
	half a2 = roughness * roughness;
	half d = (NdotH * a2 - NdotH) * NdotH + 1.0f;
	return TCP2_INV_PI * a2 / (d * d + TCP2_EPSILON);
}

half3 CalculateRamp(half ndlWrapped)
{
	#if defined(TCP2_RAMPTEXT)
		half3 ramp = tex2D(_Ramp, _RampOffset + ((ndlWrapped.xx - 0.5) * _RampScale) + 0.5).rgb;
	#elif defined(TCP2_RAMP_BANDS) || defined(TCP2_RAMP_BANDS_CRISP)
		half bands = _RampBands;

		half rampThreshold = _RampThreshold;
		half rampSmooth = _RampSmoothing * 0.5;
		half x = smoothstep(rampThreshold - rampSmooth, rampThreshold + rampSmooth, ndlWrapped);

		#if defined(TCP2_RAMP_BANDS_CRISP)
			half bandsSmooth = fwidth(ndlWrapped) * (2.0 + bands);
		#else
			half bandsSmooth = _RampBandsSmoothing * 0.5;
		#endif
		half3 ramp = saturate((smoothstep(0.5 - bandsSmooth, 0.5 + bandsSmooth, frac(x * bands)) + floor(x * bands)) / bands).xxx;
	#else
		#if defined(TCP2_RAMP_CRISP)
			half rampSmooth = fwidth(ndlWrapped) * 0.5;
		#else
			half rampSmooth = _RampSmoothing * 0.5;
		#endif
		half rampThreshold = _RampThreshold;
		half3 ramp = smoothstep(rampThreshold - rampSmooth, rampThreshold + rampSmooth, ndlWrapped).xxx;
	#endif
	return ramp;
}

half CalculateSpecular(half3 lightDir, half3 viewDir, float3 normal, half specularMap)
{
	float3 halfDir = TCP2_SafeNormalize(float3(lightDir) + float3(viewDir));
	half nh = saturate(dot(normal, halfDir));

	#if defined(TCP2_SPECULAR_STYLIZED) || defined(TCP2_SPECULAR_CRISP)
		half specSize = 1 - (_SpecularToonSize * specularMap);
		nh = nh * (1.0 / (1.0 - specSize)) - (specSize / (1.0 - specSize));

		#if defined(TCP2_SPECULAR_CRISP)
			float specSmoothness = fwidth(nh);
		#else
			float specSmoothness = _SpecularToonSmoothness;
		#endif

		half spec = smoothstep(0, specSmoothness, nh);
	#else
		float specularRoughness = max(0.00001,  _SpecularRoughness) * specularMap;
		half roughness = specularRoughness * specularRoughness;
		half spec = GGX(nh, saturate(roughness));
		spec *= TCP2_PI * 0.05;
		#ifdef UNITY_COLORSPACE_GAMMA
			spec = max(0, sqrt(max(1e-4h, spec)));
			half surfaceReduction = 1.0 - 0.28 * roughness * specularRoughness;
		#else
			half surfaceReduction = 1.0 / (roughness*roughness + 1.0);
		#endif
		spec *= surfaceReduction;
	#endif

	return max(0, spec);
}

#if defined(_DBUFFER)
	// Derived from 'ApplyDecal' in URP's DBuffer.hlsl, directly fetch the decal data so that we can blend it accordingly
	DecalSurfaceData GetDecals(float4 positionCS)
	{
		FETCH_DBUFFER(DBuffer, _DBufferTexture, int2(positionCS.xy));

		DecalSurfaceData decalSurfaceData = (DecalSurfaceData)0;
		DECODE_FROM_DBUFFER(DBuffer, decalSurfaceData);

		#if !defined(_DBUFFER_MRT3)
			decalSurfaceData.MAOSAlpha = 0;
		#endif

		return decalSurfaceData;
	}
#endif

// Custom macros to separate shadows from attenuation
// Based on UNITY_LIGHT_ATTENUATION macros from "AutoLight.cginc"

#ifdef POINT
#	define TCP2_LIGHT_ATTENUATION(input, worldPos) \
		unityShadowCoord3 lightCoord = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xyz; \
		half shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
		half attenuation = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).r;
#endif

#ifdef SPOT
#	define TCP2_LIGHT_ATTENUATION(input, worldPos) \
		DECLARE_LIGHT_COORD(input, worldPos); \
		half shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
		half attenuation = (lightCoord.z > 0) * UnitySpotCookie(lightCoord) * UnitySpotAttenuate(lightCoord.xyz);
#endif

#ifdef DIRECTIONAL
#	define TCP2_LIGHT_ATTENUATION(input, worldPos) \
		half shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
		half attenuation = 1;
#endif

#ifdef POINT_COOKIE
#	define TCP2_LIGHT_ATTENUATION(input, worldPos) \
		DECLARE_LIGHT_COORD(input, worldPos); \
		half shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
		half attenuation = tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).r * texCUBE(_LightTexture0, lightCoord).w;
#endif

#ifdef DIRECTIONAL_COOKIE
#	define TCP2_LIGHT_ATTENUATION(input, worldPos) \
		DECLARE_LIGHT_COORD(input, worldPos); \
		half shadow = UNITY_SHADOW_ATTENUATION(input, worldPos); \
		half attenuation = tex2D(_LightTexture0, lightCoord).w;
#endif

#if (defined(LIGHTMAP_ON) || defined(UNITY_PASS_META)) \
|| (defined(SHADOWS_SCREEN) && !defined(LIGHTMAP_ON) && !defined(UNITY_NO_SCREENSPACE_SHADOWS) && defined(SHADOWS_SHADOWMASK) && !defined(SHADER_API_GLES)) \
|| defined(SHADOWS_SHADOWMASK) \
|| defined(TCP2_UV2_AS_NORMALS) \
|| (!defined(TCP2_HYBRID_URP) && defined(TCP2_OUTLINE_LIGHTING_ALL))
	#define NEEDS_TEXCOORD1
#endif

// Vertex input
struct Attributes
{
	float4 vertex         : POSITION;
	float3 normal         : NORMAL;
	float4 tangent        : TANGENT;
	float4 texcoord0      : TEXCOORD0;
	#if defined(NEEDS_TEXCOORD1)
		float2 texcoord1  : TEXCOORD1;
	#endif
	#if defined(DYNAMICLIGHTMAP_ON) || defined(UNITY_PASS_META)
		float2 texcoord2 : TEXCOORD2;
	#endif
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

// Vertex output / Fragment input
struct Varyings
{
	float4 pos             : SV_POSITION;
	float3 normal          : NORMAL;
	float4 worldPos        : TEXCOORD0; /* w = fog coords */
	float4 texcoords       : TEXCOORD1; /* xy = main texcoords, zw = raw texcoords */
#if defined(_NORMALMAP) || (defined(TCP2_MOBILE) && (defined(TCP2_RIM_LIGHTING) || (defined(TCP2_REFLECTIONS) && defined(TCP2_REFLECTIONS_FRESNEL)))) // if normalmap or (mobile + rim or fresnel)
	float4 tangentWS       : TEXCOORD2; /* w = ndv (mobile) */
#endif
#if defined(_NORMALMAP)
	float4 bitangentWS     : TEXCOORD3;
#endif
#if defined(TCP2_MATCAP) && !defined(_NORMALMAP)
	float4 matcap          : TEXCOORD4;
#endif
#if defined(TCP2_HYBRID_URP)
	#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
		float4 shadowCoord : TEXCOORD5; // compute shadow coord per-vertex for the main light
	#endif
	#ifdef _ADDITIONAL_LIGHTS_VERTEX
		half3 vertexLights : TEXCOORD6;
	#endif
	#if defined(LIGHTMAP_ON) && defined(DYNAMICLIGHTMAP_ON)
		float4 lightmapUV  : TEXCOORD7;
		#define staticLightmapUV lightmapUV.xy
		#define dynamicLightmapUV lightmapUV.zw
	#elif defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
		float2 lightmapUV  : TEXCOORD7;
		#define staticLightmapUV lightmapUV.xy
		#define dynamicLightmapUV lightmapUV.xy
	#endif
#else
	#if defined(DYNAMICLIGHTMAP_ON) || defined(LIGHTMAP_ON)
		float4 lmap        : TEXCOORD5;
	#endif
	#if !defined(SHADOW_CASTER_PASS)
		UNITY_LIGHTING_COORDS(6,7)
	#endif
#endif
	UNITY_VERTEX_INPUT_INSTANCE_ID
	UNITY_VERTEX_OUTPUT_STEREO
};

struct Varyings_Meta
{
	float4 positionCS   : SV_POSITION;
	float2 uv    : TEXCOORD0;
};

#if USE_FORWARD_PLUS
	// Fake InputData struct needed for Forward+ macro
	struct InputDataForwardPlusDummy
	{
		float3  positionWS;
		float2  normalizedScreenSpaceUV;
	};
#endif

#if defined(UNITY_PASS_META)
	#define VERTEX_OUTPUT Varyings_Meta
#else
	#define VERTEX_OUTPUT Varyings
#endif

VERTEX_OUTPUT Vertex(Attributes input)
{
	#if defined(UNITY_PASS_META)
		Varyings_Meta meta_output;
		#if defined(TCP2_HYBRID_URP)
			meta_output.positionCS = MetaVertexPosition(input.vertex, input.texcoord1, input.texcoord2, unity_LightmapST, unity_DynamicLightmapST);
		#else
			meta_output.positionCS = UnityMetaVertexPosition(input.vertex, input.texcoord1, input.texcoord2, unity_LightmapST, unity_DynamicLightmapST);
		#endif
		meta_output.uv = TRANSFORM_TEX(input.texcoord0, _BaseMap);
		return meta_output;
	#else

		Varyings output = (Varyings)0;

		UNITY_SETUP_INSTANCE_ID(input);
		UNITY_TRANSFER_INSTANCE_ID(input, output);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

		// Texture Coordinates
		output.texcoords.xy = input.texcoord0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
		output.texcoords.zw = input.texcoord0.xy;

		#if defined(TCP2_HYBRID_URP)
			OUTPUT_LIGHTMAP_UV(input.texcoord1, unity_LightmapST, output.staticLightmapUV);
			#ifdef DYNAMICLIGHTMAP_ON
				output.dynamicLightmapUV = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
			#endif

			VertexPositionInputs vertexInput = GetVertexPositionInputs(input.vertex.xyz);
			#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				output.shadowCoord = GetShadowCoord(vertexInput);
			#endif
			float3 positionWS = vertexInput.positionWS;
			float4 positionCS = vertexInput.positionCS;
			output.pos = positionCS;

			VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normal, input.tangent);
			float3 normalWS = vertexNormalInput.normalWS;
			#if defined(_NORMALMAP)
				float3 tangentWS = vertexNormalInput.tangentWS;
				float3 bitangentWS = vertexNormalInput.bitangentWS;
			#endif

			#ifdef _ADDITIONAL_LIGHTS_VERTEX
				// Vertex lighting
				output.vertexLights = VertexLighting(positionWS, normalWS);
			#endif
		#else
			#ifdef LIGHTMAP_ON
				output.lmap.xy = input.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				output.lmap.zw = 0;
			#endif
			#ifdef DYNAMICLIGHTMAP_ON
				output.lmap.zw = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
			#endif

			float3 positionWS = mul(UNITY_MATRIX_M, input.vertex).xyz;
			float4 positionCS = UnityWorldToClipPos(positionWS);
			output.pos = positionCS;

			half sign = half(input.tangent.w) * half(unity_WorldTransformParams.w);
			float3 normalWS = UnityObjectToWorldNormal(input.normal);
			#if defined(_NORMALMAP)
				float3 tangentWS = UnityObjectToWorldDir(input.tangent.xyz);
				float3 bitangentWS = cross(normalWS, tangentWS) * sign;
			#endif

			#if !defined(SHADOW_CASTER_PASS)
				// This Unity macro expects the vertex input to be named 'v'
				#define v input
				UNITY_TRANSFER_LIGHTING(output, input.texcoord1.xy);
			#endif
		#endif

		// world position
		output.worldPos = float4(positionWS.xyz, 0);

		// Compute fog factor
		#if defined(TCP2_HYBRID_URP)
			output.worldPos.w = ComputeFogFactor(positionCS.z);
		#else
			UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(output, positionCS);
		#endif

		// normal
		output.normal = normalWS;

		// tangent
		#if defined(_NORMALMAP) || (defined(TCP2_MOBILE) && (defined(TCP2_RIM_LIGHTING) || (defined(TCP2_REFLECTIONS) && defined(TCP2_REFLECTIONS_FRESNEL)))) // if mobile + rim or fresnel
			output.tangentWS = float4(0, 0, 0, 0);
		#endif
		#if defined(_NORMALMAP)
			output.tangentWS.xyz = tangentWS;
			output.bitangentWS.xyz = bitangentWS;
		#endif
		#if defined(TCP2_MOBILE) && (defined(TCP2_RIM_LIGHTING) || (defined(TCP2_REFLECTIONS) && defined(TCP2_REFLECTIONS_FRESNEL))) // if mobile + rim or fresnel
			// Calculate ndv in vertex shader
			#if defined(TCP2_HYBRID_URP)
				half3 viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);
			#else
				half3 viewDirWS = TCP2_SafeNormalize(UnityWorldSpaceViewDir(positionWS));
			#endif
			output.tangentWS.w = 1 - max(0, dot(viewDirWS, normalWS));
		#endif

		#if defined(TCP2_MATCAP) && !defined(_NORMALMAP)
			// MatCap
			float3 worldNorm = normalize(UNITY_MATRIX_I_M[0].xyz * input.normal.x + UNITY_MATRIX_I_M[1].xyz * input.normal.y + UNITY_MATRIX_I_M[2].xyz * input.normal.z);
			worldNorm = mul((float3x3)UNITY_MATRIX_V, worldNorm);
			float4 screenPos = ComputeScreenPos(positionCS);
			float3 perspectiveOffset = (screenPos.xyz / screenPos.w) - 0.5;
			worldNorm.xy -= (perspectiveOffset.xy * perspectiveOffset.z) * 0.5;
			output.matcap.xy = worldNorm.xy * 0.5 + 0.5;
		#endif

		return output;

	#endif
}

#if defined(TCP2_HYBRID_URP)
	void ProcessAdditionalLight(Light light, float3 normalWS, half3 albedo, inout half3 color, half lightingFactor
	#if !defined(TCP2_OUTLINE_PASS)
		, inout half3 emission
	#endif
	#if defined(_SCREEN_SPACE_OCCLUSION)
		, AmbientOcclusionFactor aoFactor
	#endif
	#if defined(TCP2_SPECULAR)
		, half specularMap
		, half3 viewDirWS
	#endif
	#if defined(TCP2_RIM_LIGHTING) && defined(TCP2_RIM_LIGHTING_LIGHTMASK)
		, half rim
	#endif
		)
	{
		#if defined(_SCREEN_SPACE_OCCLUSION)
			light.color *= aoFactor.directAmbientOcclusion;
		#endif

		half atten = light.shadowAttenuation * light.distanceAttenuation;
		half3 lightDir = light.direction;
		half3 lightColor = light.color.rgb;

		half ndl = dot(normalWS, lightDir);
		half ndlWrapped = ndl * 0.5 + 0.5;
		ndl = saturate(ndl);

		// Calculate ramp
		half3 ramp = CalculateRamp(ndlWrapped);

		// Apply attenuation (shadowmaps & point/spot lights attenuation)
		ramp *= atten;

		#if defined(TCP2_RIM_LIGHTING) && defined(TCP2_RIM_LIGHTING_LIGHTMASK)
			half3 rimMask = ramp.xxx * lightColor.rgb;
		#endif

		// Apply highlight color only
		ramp = lerp(half3(0,0,0), _HColor.rgb, ramp);

		// Output color
		IS_LIGHTING_FEATURE_ENABLED(DEBUGLIGHTINGFEATUREFLAGS_ADDITIONAL_LIGHTS)
		color += albedo.rgb * lightColor.rgb * ramp * lightingFactor;

		// Specular
		#if defined(TCP2_SPECULAR)
			half spec = CalculateSpecular(lightDir, viewDirWS, normalWS, specularMap);
			IS_LIGHTING_FEATURE_ENABLED(DEBUGLIGHTINGFEATUREFLAGS_ADDITIONAL_LIGHTS)
			emission.rgb += spec * atten * ndl * lightColor.rgb * _SpecularColor.rgb;
		#endif
		// Rim Lighting
		#if defined(TCP2_RIM_LIGHTING) && defined(TCP2_RIM_LIGHTING_LIGHTMASK)
			IS_LIGHTING_FEATURE_ENABLED(DEBUGLIGHTINGFEATUREFLAGS_ADDITIONAL_LIGHTS)
			emission.rgb += rimMask * rim * _RimColor.rgb;
		#endif
	}
#endif

// Note: calculations from the main pass are defined with UNITY_PASS_FORWARDBASE
// However it is left out sometimes because some keywords aren't defined for the
// Forward Add pass (e.g. TCP2_MATCAP, TCP2_REFLECTIONS, ...)

half4 Fragment (
	Varyings input
	, half vFace : VFACE
#ifdef _WRITE_RENDERING_LAYERS
	, out float4 outRenderingLayers : SV_Target1
#endif
	) : SV_Target
{
	UNITY_SETUP_INSTANCE_ID(input);
	UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

	#ifdef _WRITE_RENDERING_LAYERS
		outRenderingLayers = float4(0, 0, 0, 0);
	#endif

	// LOD Crossfading
	#if defined(LOD_FADE_CROSSFADE)
		const float dither = Dither4x4(input.pos.xy);
		const float ditherThreshold = unity_LODFade.x - CopySign(dither, unity_LODFade.x);
		clip(ditherThreshold);
	#endif

	// Texture coordinates
	float2 mainTexcoord = input.texcoords.xy;
	float2 rawTexcoord = input.texcoords.zw;

	// Vectors
	float3 positionWS = input.worldPos.xyz;
	float3 normalWS = normalize(input.normal);
	normalWS.xyz *= (vFace < 0) ? -1.0 : 1.0;

	#if defined(DEBUG_DISPLAY)
		InputData debugInputData = (InputData)0;
		debugInputData.positionWS = positionWS;
		debugInputData.positionCS = input.pos;

		SurfaceData debugSurfaceData = (SurfaceData)0;
	#endif

	#if defined(TCP2_HYBRID_URP)
		half3 viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);
	#else
		half3 viewDirWS = TCP2_SafeNormalize(UnityWorldSpaceViewDir(positionWS));
	#endif
	#if defined(_NORMALMAP)
		half3 tangentWS = input.tangentWS.xyz;
		half3 bitangentWS = input.bitangentWS.xyz;
		half3x3 tangentToWorldMatrix = half3x3(tangentWS.xyz, bitangentWS.xyz, normalWS.xyz);
	#endif

	// Base

	half4 albedo = tex2D(_BaseMap, mainTexcoord).rgba;
	albedo.rgb *= _BaseColor.rgb;
	half alpha = albedo.a * _BaseColor.a;
	half3 emission = half3(0,0,0);

	// Normal Mapping
	#if defined(_NORMALMAP)
		half4 normalMap = tex2D(_BumpMap, rawTexcoord * _BumpMap_ST.xy + _BumpMap_ST.zw).rgba;
		half3 normalTS = UnpackScaleNormal(normalMap, _BumpScale);
		normalWS = mul(normalTS, tangentToWorldMatrix);

		#if defined(DEBUG_DISPLAY)
			if (_DebugLightingMode == DEBUGLIGHTINGMODE_LIGHTING_WITHOUT_NORMAL_MAPS || _DebugLightingMode == DEBUGLIGHTINGMODE_REFLECTIONS)
			{
				// Cancel normal map for rendering debugger
				normalWS = normalize(input.normal);
			}
		#endif
	#endif

	// URP Decals
	#if defined(_DBUFFER)
		#if defined(_DBUFFER_MRT2) || defined(_DBUFFER_MRT3)
			#define HAS_DECAL_NORMALS
		#endif
		#if defined(_DBUFFER_MRT3)
			#define HAS_DECAL_MAOS
		#endif

		DecalSurfaceData decals = GetDecals(input.pos);
		albedo.rgb = albedo.rgb * decals.baseColor.a + decals.baseColor.rgb;
		#if defined(HAS_DECAL_NORMALS)
			// Always test the normal as we can have decompression artifact
			if (decals.normalWS.w < 1.0)
			{
				normalWS.xyz = normalize(normalWS.xyz * decals.normalWS.w + decals.normalWS.xyz);
			}
		#endif
	#endif

	// Alpha Testing
	#if defined(_ALPHATEST_ON)
		clip(alpha - _Cutoff);
	#endif

	// Emission
	#if defined(_EMISSION)
		emission = _EmissionColor.rgb;
		#if defined(TCP2_MOBILE)
			half4 emissionMap = tex2D(_EmissionMap, rawTexcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw);
			emission *= emissionMap.rgb;
		#else
			if (_EmissionChannel < 5)
			{
				half4 emissionMap = tex2D(_EmissionMap, rawTexcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw);
				if (_EmissionChannel >= 4)		emission *= emissionMap.rgb;
				else if (_EmissionChannel >= 3)	emission *= emissionMap.a;
				else if (_EmissionChannel >= 2) emission *= emissionMap.b;
				else if (_EmissionChannel >= 1) emission *= emissionMap.g;
				else							emission *= emissionMap.r;
			}
		#endif
		#if defined(DEBUG_DISPLAY)
			debugSurfaceData.emission = emission;
		#endif
	#endif

	#if defined(UNITY_PASS_META)
		half3 meta_albedo = albedo.rgb;
		half3 meta_emission = emission.rgb;
		half3 meta_specular = half3(0, 0, 0);
	#endif

	// MatCap
	#if defined(TCP2_MATCAP)
		#if defined(_NORMALMAP)
			half3 matcapCoordsNormal = mul((float3x3)UNITY_MATRIX_V, normalWS);
			half3 matcap = tex2D(_MatCapTex, matcapCoordsNormal.xy * 0.5 + 0.5).rgb * _MatCapColor.rgb;
		#else
			half3 matcap = tex2D(_MatCapTex, input.matcap.xy).rgb * _MatCapColor.rgb;
		#endif
		half matcapMask = 1.0;
		#if defined(TCP2_MATCAP_MASK)
			half4 matcapMaskTex = tex2D(_MatCapMask, mainTexcoord);
			#if defined(TCP2_MOBILE)
				matcapMask *= matcapMaskTex.a;
			#else
				if (_MatCapMaskChannel >= 3)
				{
					matcapMask *= matcapMaskTex.a;
				}
				else if (_MatCapMaskChannel >= 2)
				{
					matcapMask *= matcapMaskTex.b;
				}
				else if (_MatCapMaskChannel >= 1)
				{
					matcapMask *= matcapMaskTex.g;
				}
				else
				{
					matcapMask *= matcapMaskTex.r;
				}
			#endif
		#endif

		#if defined(TCP2_MOBILE)
			emission += matcap * matcapMask;
		#else
			if (_MatCapType >= 1)
			{
				albedo.rgb = lerp(albedo.rgb, matcap.rgb, matcapMask);
			}
			else
			{
				emission += matcap * matcapMask;
			}
		#endif
	#endif

	// Lighting

	// Occlusion
	#if defined(TCP2_OCCLUSION)
		#if defined(TCP2_MOBILE)
			half occlusion = tex2D(_OcclusionMap, mainTexcoord).a;
		#else
			half occlusion = 1.0;
			if (_OcclusionChannel >= 4)
			{
				occlusion = tex2D(_OcclusionMap, mainTexcoord).a;
			}
			else if (_OcclusionChannel >= 3)
			{
				occlusion = tex2D(_OcclusionMap, mainTexcoord).b;
			}
			else if (_OcclusionChannel >= 2)
			{
				occlusion = tex2D(_OcclusionMap, mainTexcoord).g;
			}
			else if (_OcclusionChannel >= 1)
			{
				occlusion = tex2D(_OcclusionMap, mainTexcoord).r;
			}
			else
			{
				occlusion = albedo.a;
			}
		#endif
		occlusion = lerp(1, occlusion, _OcclusionStrength);
	#else
		half occlusion = 1.0;
	#endif
	#if defined(HAS_DECAL_MAOS)
		occlusion = occlusion * decals.MAOSAlpha + decals.occlusion;
	#endif

	#if defined(TCP2_HYBRID_URP) && defined(_SCREEN_SPACE_OCCLUSION)
		float2 normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.pos);
		AmbientOcclusionFactor aoFactor = GetScreenSpaceAmbientOcclusion(normalizedScreenSpaceUV);
		occlusion = min(occlusion, aoFactor.indirectAmbientOcclusion);
	#endif

	// Setup lighting environment (Built-In)
	#if !defined(TCP2_HYBRID_URP)
		half3 lightDir = normalize(UnityWorldSpaceLightDir(positionWS));
		half3 lightColor = _LightColor0.rgb;
		#if defined(SHADOW_CASTER_PASS)
			half atten = 1.0;
		#else
			TCP2_LIGHT_ATTENUATION(input, positionWS)
			#if defined(_RECEIVE_SHADOWS_OFF)
				half atten = attenuation;
			#else
				half atten = shadow * attenuation;
			#endif
		#endif
	#endif

	#if !defined(TCP2_HYBRID_URP) && defined(UNITY_PASS_FORWARDBASE)
		UnityGI gi;
		UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
		gi.indirect.diffuse = 0;
		gi.indirect.specular = 0;
		gi.light.color = lightColor;
		gi.light.dir = lightDir;

		// Call GI (lightmaps/SH/reflections) lighting function
		UnityGIInput giInput;
		UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
		giInput.light = gi.light;
		giInput.worldPos = positionWS;
		giInput.worldViewDir = viewDirWS;
		giInput.atten = atten;
		#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
			giInput.lightmapUV = input.lmap;
		#else
			giInput.lightmapUV = 0.0;
		#endif
		giInput.ambient.rgb = 0.0;
		giInput.probeHDR[0] = unity_SpecCube0_HDR;
		giInput.probeHDR[1] = unity_SpecCube1_HDR;
		#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
			giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
		#endif
		#ifdef UNITY_SPECCUBE_BOX_PROJECTION
			giInput.boxMax[0] = unity_SpecCube0_BoxMax;
			giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
			giInput.boxMax[1] = unity_SpecCube1_BoxMax;
			giInput.boxMin[1] = unity_SpecCube1_BoxMin;
			giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
		#endif

		half3 shNormal = (_SingleIndirectColor > 0) ? viewDirWS : normalWS;
		#if defined(TCP2_REFLECTIONS)
			// GI: indirect diffuse & specular
			half smoothness = _ReflectionSmoothness;
			Unity_GlossyEnvironmentData g = UnityGlossyEnvironmentSetup(smoothness, giInput.worldViewDir, normalWS, half3(0,0,0));
			gi = UnityGlobalIllumination(giInput, occlusion, shNormal, g);
		#else
			// GI: indirect diffuse only
			gi = UnityGlobalIllumination(giInput, occlusion, shNormal);
		#endif

		gi.light.color = _LightColor0.rgb; // remove attenuation, taken into account separately
	#endif

	#if defined(TCP2_HYBRID_URP)
		#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
			float4 shadowCoord = input.shadowCoord;
		#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
			float4 shadowCoord = TransformWorldToShadowCoord(positionWS);
		#else
			float4 shadowCoord = float4(0, 0, 0, 0);
		#endif

		#if defined(USE_APV_PROBE_OCCLUSION)
			half4 shadowMask = probeOcclusion;
		#elif defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
			half4 shadowMask = SAMPLE_SHADOWMASK(input.staticLightmapUV);
		#elif !defined (LIGHTMAP_ON)
			half4 shadowMask = unity_ProbesOcclusion;
		#else
			half4 shadowMask = half4(1, 1, 1, 1);
		#endif

		#if defined(DEBUG_DISPLAY)
			debugInputData.shadowMask = shadowMask;
		#endif

		#if URP_VERSION <= 7
			Light mainLight = GetMainLight(shadowCoord);
		#else
			Light mainLight = GetMainLight(shadowCoord, positionWS, shadowMask);
		#endif
	#endif

	// Ambient/indirect lighting
	#if defined(UNITY_PASS_FORWARDBASE)
		half3 indirectDiffuse = 0;
		#if !defined(TCP2_MOBILE)
		if (_IndirectIntensity > 0)
		#endif
		{
			#if defined(TCP2_HYBRID_URP)
					// Normal is required in case Directional lightmaps are baked
				#if defined(LIGHTMAP_ON) && defined(DYNAMICLIGHTMAP_ON)
					// Static & Dynamic Lightmap
					half3 bakedGI = SampleLightmap(input.staticLightmapUV, input.dynamicLightmapUV, normalWS);
					MixRealtimeAndBakedGI(mainLight, normalWS, bakedGI, half4(0, 0, 0, 0));
				#elif defined(LIGHTMAP_ON)
					// Static Lightmap
					half3 bakedGI = SampleLightmap(input.staticLightmapUV, 0, normalWS);
					MixRealtimeAndBakedGI(mainLight, normalWS, bakedGI, half4(0, 0, 0, 0));
				#elif defined(DYNAMICLIGHTMAP_ON)
					// Dynamic Lightmap
					half3 bakedGI = SampleLightmap(0, input.dynamicLightmapUV, normalWS);
					MixRealtimeAndBakedGI(mainLight, normalWS, bakedGI, half4(0, 0, 0, 0));
				#elif defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2)
					// Adaptive Probe Volumes APV
					#ifdef USE_APV_PROBE_OCCLUSION
						float4 probeOcclusion;
						half3 bakedGI = SampleProbeVolumePixel(0.0, positionWS, normalWS, viewDirWS, input.pos.xy, 1.0, probeOcclusion);
					#else
						half3 bakedGI = SampleProbeVolumePixel(0.0, positionWS, normalWS, viewDirWS, input.pos.xy);
					#endif
				#else
					// Sample SH fully per-pixel
					half3 bakedGI = SampleSH(_SingleIndirectColor > 0 ? viewDirWS : normalWS);
				#endif
				#if defined(DEBUG_DISPLAY)
					debugInputData.bakedGI = bakedGI;
				#endif
				indirectDiffuse = bakedGI * occlusion * albedo.rgb * _IndirectIntensity;
			#else
				indirectDiffuse = gi.indirect.diffuse * albedo.rgb * _IndirectIntensity;
			#endif
		}
	#endif

	#if defined(TCP2_HYBRID_URP)
		#if URP_VERSION >= 14
			uint meshRenderingLayers = GetMeshRenderingLayer();
		#elif URP_VERSION >= 12
			uint meshRenderingLayers = GetMeshRenderingLightLayer();
		#endif

		#if defined(_SCREEN_SPACE_OCCLUSION)
			mainLight.color *= aoFactor.directAmbientOcclusion;
		#endif

		#if URP_VERSION >= 12
			half3 lightDir = half3(0, 1, 0);
			half3 lightColor = half3(0, 0, 0);
			#if (URP_VERSION >= 14 && defined(_LIGHT_LAYERS)) || URP_VERSION <= 12
				if (IsMatchingLightLayer(mainLight.layerMask, meshRenderingLayers))
			#endif
				{
					lightDir = mainLight.direction;
					lightColor = mainLight.color.rgb;
				}
		#else
			half3 lightDir = mainLight.direction;
			half3 lightColor = mainLight.color.rgb;
		#endif
		half atten = mainLight.shadowAttenuation * mainLight.distanceAttenuation;
	#endif

	half ndl = dot(normalWS, lightDir);
	half ndlWrapped = ndl * 0.5 + 0.5;
	ndl = saturate(ndl);

	// Calculate ramp
	half3 ramp = CalculateRamp(ndlWrapped);

	// Apply attenuation
	ramp *= atten;
	#if defined(TCP2_RIM_LIGHTING)
		#if defined(TCP2_RIM_LIGHTING_LIGHTMASK)
			half3 rimMask = ramp.xxx * lightColor.rgb;
		#else
			half3 rimMask = half3(1, 1, 1);
		#endif
	#endif

	// Shadow Albedo
	#if defined(TCP2_SHADOW_TEXTURE)
		half4 shadowAlbedo = tex2D(_ShadowBaseMap, mainTexcoord).rgba;
		albedo = lerp(shadowAlbedo, albedo, ramp.x);
	#endif

	// Highlight/shadow colors
	#if !defined(TCP2_SHADOW_LIGHT_COLOR)
		half3 highlightColor = _HColor.rgb * lightColor.rgb;
	#else
		half3 highlightColor = _HColor.rgb;
	#endif
	#if defined(UNITY_PASS_FORWARDBASE) || defined(DIRECTIONAL_COOKIE)
		ramp = lerp(_SColor.rgb, highlightColor, ramp);
	#else
		ramp = lerp(half3(0, 0, 0), highlightColor, ramp);
	#endif

	#if defined(TCP2_SHADOW_LIGHT_COLOR)
		ramp *= lightColor.rgb;
	#endif

	#if defined(DEBUG_DISPLAY)
		// Lighting overlays:
		if (_DebugLightingMode == DEBUGLIGHTINGMODE_SHADOW_CASCADES)
		{
			albedo.rgb = CalculateDebugShadowCascadeColor(debugInputData);
		}
		else if (_DebugLightingMode == DEBUGLIGHTINGMODE_LIGHTING_WITHOUT_NORMAL_MAPS || _DebugLightingMode == DEBUGLIGHTINGMODE_LIGHTING_WITH_NORMAL_MAPS)
		{
			albedo.rgb = half3(1, 1, 1);
		}
	#endif

	// Output color
	half3 color = albedo.rgb * ramp;

	#if defined(DEBUG_DISPLAY)
		if (!IsLightingFeatureEnabled(DEBUGLIGHTINGFEATUREFLAGS_MAIN_LIGHT))
		{
			// Cancel main light for rendering debugger
			color = 0;
		}
	#endif

	// Apply ambient/indirect lighting
	#if defined(UNITY_PASS_FORWARDBASE)
		#if !defined(TCP2_MOBILE)
		if (_IndirectIntensity > 0)
		#endif
		{
			#if defined(TCP2_HYBRID_URP)
			IS_LIGHTING_FEATURE_ENABLED(DEBUGLIGHTINGFEATUREFLAGS_GLOBAL_ILLUMINATION)
			#endif
			color.rgb += indirectDiffuse;
		}
	#endif


	// Calculate N.V
	#if defined(TCP2_RIM_LIGHTING) || (defined(TCP2_REFLECTIONS) && defined(TCP2_REFLECTIONS_FRESNEL))
		#if defined(TCP2_MOBILE)
			half ndv = input.tangentWS.w;
		#else
			half ndv = 1 - max(0, dot(viewDirWS, normalWS));
		#endif
	#endif

	// Rim Lighting
	#if defined(TCP2_RIM_LIGHTING)
		#if defined(UNITY_PASS_FORWARDBASE) || defined(TCP2_RIM_LIGHTING_LIGHTMASK)
			half rim = smoothstep(_RimMin, _RimMax, ndv);
			IS_LIGHTING_FEATURE_ENABLED(DEBUGLIGHTINGFEATUREFLAGS_MAIN_LIGHT)
			emission.rgb += rimMask.rgb * rim * _RimColor.rgb;
		#endif
	#endif

	// Specular
	#if defined(TCP2_SPECULAR)

		half specularMap = 1.0;
		#if defined(TCP2_MOBILE)
			specularMap *= tex2D(_SpecGlossMap, mainTexcoord).a;
		#else
			if (_SpecularMapType >= 5)
			{
				specularMap *= tex2D(_SpecGlossMap, mainTexcoord).a;
			}
			else if (_SpecularMapType >= 4)
			{
				specularMap *= tex2D(_SpecGlossMap, mainTexcoord).b;
			}
			else if (_SpecularMapType >= 3)
			{
				specularMap *= tex2D(_SpecGlossMap, mainTexcoord).g;
			}
			else if (_SpecularMapType >= 2)
			{
				specularMap *= tex2D(_SpecGlossMap, mainTexcoord).r;
			}
			else if (_SpecularMapType >= 1)
			{
				specularMap *= albedo.a;
			}
		#endif
		#if defined(HAS_DECAL_MAOS)
			specularMap = specularMap * decals.MAOSAlpha + decals.smoothness;
		#endif

		half spec = CalculateSpecular(lightDir, viewDirWS, normalWS, specularMap);
		IS_LIGHTING_FEATURE_ENABLED(DEBUGLIGHTINGFEATUREFLAGS_MAIN_LIGHT)
		emission.rgb += spec * atten * ndl * lightColor.rgb * _SpecularColor.rgb;

		#if defined(DEBUG_DISPLAY)
			debugSurfaceData.specular = _SpecularColor.rgb;
		#endif

		#if defined(UNITY_PASS_META)
			meta_specular = specularMap * _SpecularColor.rgb;
			meta_albedo += specularMap * _SpecularColor.rgb * max(0.00001, _SpecularRoughness * _SpecularRoughness) * 0.5;
		#endif

	#endif

	// Meta pass
	#if defined(UNITY_PASS_META)
		#if defined(TCP2_HYBRID_URP)
			MetaInput metaInput;
		#else
			UnityMetaInput metaInput;
			UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaInput);
		#endif
		metaInput.Albedo = meta_albedo.rgb;
		metaInput.Emission = meta_emission.rgb;
		#if !defined(TCP2_HYBRID_URP)
			metaInput.SpecularColor = meta_specular.rgb;
		#endif

		#if defined(TCP2_HYBRID_URP)
			return MetaFragment(metaInput);
		#else
			return UnityMetaFragment(metaInput);
		#endif
	#endif

	// Additional lights loop
	#if defined(TCP2_HYBRID_URP) && defined(_ADDITIONAL_LIGHTS)
		uint pixelLightCount = GetAdditionalLightsCount();
		#if URP_VERSION >= 12
			#if USE_FORWARD_PLUS
				// Additional directional lights in Forward+
				for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
				{
					FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

					Light light = GetAdditionalLight(lightIndex, positionWS, shadowMask);

					#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
					#endif
					{
						ProcessAdditionalLight(light, normalWS, albedo.rgb, color, 1.0
							#if !defined(TCP2_OUTLINE_PASS)
								, emission
							#endif
							#if defined(_SCREEN_SPACE_OCCLUSION)
								, aoFactor
							#endif
							#if defined(TCP2_SPECULAR)
								, specularMap
								, viewDirWS
							#endif
							#if defined(TCP2_RIM_LIGHTING) && defined(TCP2_RIM_LIGHTING_LIGHTMASK)
								, rim
							#endif
						);
					}
				}

				// Data with dummy struct used in Forward+ macro (LIGHT_LOOP_BEGIN)
				#if !defined(_SCREEN_SPACE_OCCLUSION)
					float2 normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.pos);
				#endif
				InputDataForwardPlusDummy inputData;
				inputData.normalizedScreenSpaceUV = normalizedScreenSpaceUV;
				inputData.positionWS = positionWS;
			#endif

			LIGHT_LOOP_BEGIN(pixelLightCount)
		#else
			for (uint lightIndex = 0u; lightIndex < pixelLightCount; ++lightIndex)
			{
		#endif

		#if URP_VERSION <= 7
				Light light = GetAdditionalLight(lightIndex, positionWS);
		#else
				Light light = GetAdditionalLight(lightIndex, positionWS, shadowMask);
		#endif

		#if (URP_VERSION >= 12 && URP_VERSION < 14) || (URP_VERSION >= 14 && defined(_LIGHT_LAYERS))
			if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
		#endif
			{
				ProcessAdditionalLight(light, normalWS, albedo.rgb, color, 1.0
					#if !defined(TCP2_OUTLINE_PASS)
						, emission
					#endif
					#if defined(_SCREEN_SPACE_OCCLUSION)
						, aoFactor
					#endif
					#if defined(TCP2_SPECULAR)
						, specularMap
						, viewDirWS
					#endif
					#if defined(TCP2_RIM_LIGHTING) && defined(TCP2_RIM_LIGHTING_LIGHTMASK)
						, rim
					#endif
				);
			}
		#if URP_VERSION >= 12
			LIGHT_LOOP_END
		#else
			}
		#endif

		#ifdef _ADDITIONAL_LIGHTS_VERTEX
			IS_LIGHTING_FEATURE_ENABLED(DEBUGLIGHTINGFEATUREFLAGS_VERTEX_LIGHTING)
			color += input.vertexLights * albedo.rgb;
		#endif
	#endif

	// Environment Reflection
	#if defined(TCP2_REFLECTIONS)
		half3 reflections = half3(0, 0, 0);

		half reflectionRoughness = _ReflectionSmoothness;
		#if defined(DEBUG_DISPLAY)
			if (_DebugLightingMode == DEBUGLIGHTINGMODE_REFLECTIONS) reflectionRoughness = 1.0;
		#endif
		half reflectionMask = 1.0;
		#if defined(TCP2_MOBILE)
			reflectionRoughness *= tex2D(_ReflectionTex, mainTexcoord).a;
		#else
			if (_ReflectionMapType > 0)
			{
				if (_ReflectionMapType <= 1)
				{
					reflectionRoughness *= albedo.a;
				}
				else if (_ReflectionMapType <= 2)
				{
					reflectionRoughness *= tex2D(_ReflectionTex, mainTexcoord).r;
				}
				else if (_ReflectionMapType <= 3)
				{
					reflectionRoughness *= tex2D(_ReflectionTex, mainTexcoord).g;
				}
				else if (_ReflectionMapType <= 4)
				{
					reflectionRoughness *= tex2D(_ReflectionTex, mainTexcoord).b;
				}
				else if (_ReflectionMapType <= 5)
				{
					reflectionRoughness *= tex2D(_ReflectionTex, mainTexcoord).a;
				}
				else if (_ReflectionMapType <= 6)
				{
					reflectionMask *= albedo.a;
				}
				else if (_ReflectionMapType <= 7)
				{
					reflectionMask *= tex2D(_ReflectionTex, mainTexcoord).r;
				}
				else if (_ReflectionMapType <= 8)
				{
					reflectionMask *= tex2D(_ReflectionTex, mainTexcoord).g;
				}
				else if (_ReflectionMapType <= 9)
				{
					reflectionMask *= tex2D(_ReflectionTex, mainTexcoord).b;
				}
				else if (_ReflectionMapType <= 10)
				{
					reflectionMask *= tex2D(_ReflectionTex, mainTexcoord).a;
				}
			}
		#endif
		#if defined(HAS_DECAL_MAOS)
			reflectionRoughness = reflectionRoughness * decals.MAOSAlpha + decals.smoothness;
		#endif
		reflectionRoughness = 1 - reflectionRoughness;

		#if defined(TCP2_HYBRID_URP)
			half3 reflectVector = reflect(-viewDirWS, normalWS);
			#if USE_FORWARD_PLUS
				half3 indirectSpecular = GlossyEnvironmentReflection(reflectVector, positionWS, reflectionRoughness, occlusion, normalizedScreenSpaceUV);
			#else
				half3 indirectSpecular = GlossyEnvironmentReflection(reflectVector, reflectionRoughness, occlusion);
			#endif
		#else
			half3 indirectSpecular = gi.indirect.specular;
		#endif
		half reflectionRoughness4 = max(pow(reflectionRoughness, 4), 6.103515625e-5);
		float surfaceReductionRefl = 1.0 / (reflectionRoughness4 + 1.0);
		reflections += indirectSpecular * reflectionMask * surfaceReductionRefl * _ReflectionColor.rgb;

		#if defined(TCP2_REFLECTIONS_FRESNEL)
			half fresnelTerm = smoothstep(_FresnelMin, _FresnelMax, ndv);
			reflections *= fresnelTerm;
		#endif

		IS_LIGHTING_FEATURE_ENABLED(DEBUGLIGHTINGFEATUREFLAGS_GLOBAL_ILLUMINATION)
		emission.rgb += reflections;
	#endif

	// Premultiply blending
	#if defined(_ALPHAPREMULTIPLY_ON)
		color.rgb *= alpha;
	#endif

	// Rendering Debugger
	#if defined(DEBUG_DISPLAY)
		debugInputData.normalWS = normalWS;
		debugInputData.viewDirectionWS = viewDirWS;
		debugInputData.shadowCoord = shadowCoord;
		debugInputData.fogCoord = input.worldPos.w;
		debugInputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.pos);
		#ifdef _ADDITIONAL_LIGHTS_VERTEX
		debugInputData.vertexLighting = input.vertexLights;
		#endif
		#if defined(_NORMALMAP)
		debugInputData.tangentToWorld = tangentToWorldMatrix;
		debugSurfaceData.normalTS = normalTS;
		#endif

		debugSurfaceData.albedo = albedo.rgb;
		debugSurfaceData.occlusion = occlusion;
		debugSurfaceData.alpha = alpha;

		// Material overrides:
		half4 debugColor;
		if (CanDebugOverrideOutputColor(debugInputData, debugSurfaceData, debugColor))
		{
			return debugColor;
		}

		// Lighting overlays:
		if (_DebugLightingMode == DEBUGLIGHTINGMODE_LIGHTING_WITHOUT_NORMAL_MAPS || _DebugLightingMode == DEBUGLIGHTINGMODE_LIGHTING_WITH_NORMAL_MAPS)
		{
			emission = 0;
		}
		#if defined(TCP2_REFLECTIONS)
			else if (_DebugLightingMode == DEBUGLIGHTINGMODE_REFLECTIONS || _DebugLightingMode == DEBUGLIGHTINGMODE_REFLECTIONS_WITH_SMOOTHNESS)
			{
				color.rgb = half3(0, 0, 0);
				emission.rgb = reflections;
			}
		#endif
	#endif

	color += emission;

	// Fog
	#if defined(TCP2_HYBRID_URP)
		color = MixFog(color, input.worldPos.w);
	#else
		UNITY_EXTRACT_FOG_FROM_WORLD_POS(input);
		UNITY_APPLY_FOG(_unity_fogCoord, color);
	#endif

	#if defined(TCP2_HYBRID_URP) && URP_VERSION >= 14 && defined(_WRITE_RENDERING_LAYERS)
		outRenderingLayers = float4(EncodeMeshRenderingLayer(meshRenderingLayers), 0, 0, 0);
	#endif

	return half4(color, alpha);
}

//================================================================================================================================
//================================================================================================================================

// OUTLINE

//================================================================================================================================
//================================================================================================================================

#if defined(TCP2_OUTLINE_LIGHTING_MAIN) || (defined(TCP2_HYBRID_URP) && defined(TCP2_OUTLINE_LIGHTING_ALL)) || defined(TCP2_OUTLINE_LIGHTING_INDIRECT)
	#define TCP2_OUTLINE_LIGHTING
#endif

struct Attributes_Outline
{
	float4 vertex : POSITION;
	float3 normal : NORMAL;
#if defined(TCP2_UV1_AS_NORMALS) || defined(TCP2_OUTLINE_TEXTURED_VERTEX) || defined(TCP2_OUTLINE_TEXTURED_FRAGMENT)
	float4 texcoord0 : TEXCOORD0;
#endif
#if defined(NEEDS_TEXCOORD1)
	float4 texcoord1 : TEXCOORD1;
#endif
#if defined(TCP2_UV3_AS_NORMALS)
	float4 texcoord2 : TEXCOORD2;
#endif
#if defined(TCP2_UV4_AS_NORMALS)
	float4 texcoord3 : TEXCOORD3;
#endif
#if defined(TCP2_COLORS_AS_NORMALS)
	float4 vertexColor : COLOR;
#endif
#if defined(TCP2_TANGENT_AS_NORMALS) || (defined(TCP2_OUTLINE_LIGHTING_ALL) && defined(_ADDITIONAL_LIGHTS_VERTEX))
	float4 tangent : TANGENT;
#endif
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings_Outline
{
	float4 pos       : SV_POSITION;
	float4 vcolor    : TEXCOORD0;
	float4 worldPos  : TEXCOORD1; // xyz = worldPos  w = fogFactor
#if defined(TCP2_OUTLINE_TEXTURED_FRAGMENT)
	float4 texcoord0 : TEXCOORD2;
#endif
#if defined(TCP2_OUTLINE_LIGHTING)
	float3 normal    : TEXCOORD3;
#endif
#if defined(TCP2_HYBRID_URP)
	#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
		float4 shadowCoord    : TEXCOORD4; // compute shadow coord per-vertex for the main light
	#endif
	#if defined(TCP2_HYBRID_URP) && defined(TCP2_OUTLINE_LIGHTING_ALL) && defined(_ADDITIONAL_LIGHTS_VERTEX)
		half3 vertexLights : TEXCOORD5;
	#endif
#else
	#if !defined(SHADOW_CASTER_PASS)
		UNITY_LIGHTING_COORDS(5,6)
	#endif
#endif
	UNITY_VERTEX_INPUT_INSTANCE_ID
	UNITY_VERTEX_OUTPUT_STEREO
};

Varyings_Outline vertex_outline (Attributes_Outline input)
{
	Varyings_Outline output = (Varyings_Outline)0;

	UNITY_SETUP_INSTANCE_ID(input);
	UNITY_TRANSFER_INSTANCE_ID(input, output);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

	#if defined(TCP2_HYBRID_URP)
		VertexPositionInputs vertexInput = GetVertexPositionInputs(input.vertex.xyz);
		#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
			output.shadowCoord = GetShadowCoord(vertexInput);
		#endif
		float3 positionWS = vertexInput.positionWS;
	#else
		float3 positionWS = mul(UNITY_MATRIX_M, input.vertex).xyz;
		#if !defined(SHADOW_CASTER_PASS)
			UNITY_TRANSFER_LIGHTING(output, input.texcoord1.xy);
		#endif
	#endif

	#ifdef TCP2_COLORS_AS_NORMALS
		//Vertex Color for Normals
		float3 normal = (input.vertexColor.xyz*2) - 1;
	#elif TCP2_TANGENT_AS_NORMALS
		//Tangent for Normals
		float3 normal = input.tangent.xyz;
	#elif TCP2_UV1_AS_NORMALS || TCP2_UV2_AS_NORMALS || TCP2_UV3_AS_NORMALS || TCP2_UV4_AS_NORMALS
		#if TCP2_UV1_AS_NORMALS
			#define uvChannel texcoord0
		#elif TCP2_UV2_AS_NORMALS
			#define uvChannel texcoord1
		#elif TCP2_UV3_AS_NORMALS
			#define uvChannel texcoord2
		#elif TCP2_UV4_AS_NORMALS
			#define uvChannel texcoord3
		#endif

		#if TCP2_UV_NORMALS_FULL
		//UV for Normals, full
		float3 normal = input.uvChannel.xyz;
		#else
		//UV for Normals, compressed
		#if TCP2_UV_NORMALS_ZW
			#define ch1 z
			#define ch2 w
		#else
			#define ch1 x
			#define ch2 y
		#endif
		float3 n;
		//unpack uvs
		input.uvChannel.ch1 = input.uvChannel.ch1 * 255.0/16.0;
		n.x = floor(input.uvChannel.ch1) / 15.0;
		n.y = frac(input.uvChannel.ch1) * 16.0 / 15.0;
		//- get z
		n.z = input.uvChannel.ch2;
		//- transform
		n = n*2 - 1;
		float3 normal = n;
		#endif
	#else
		float3 normal = input.normal;
	#endif

	/// #if TCP2_ZSMOOTH_ON
		/// //Correct Z artefacts
		/// normal = UnityObjectToViewPos(normal);
		/// normal.z = -_ZSmooth;
	/// #endif

	#if !defined(SHADOW_CASTER_PASS)
		output.pos = UnityObjectToClipPos(input.vertex.xyz);
		normal = mul(UNITY_MATRIX_M, float4(normal, 0)).xyz;
		float2 clipNormals = normalize(mul(UNITY_MATRIX_VP, float4(normal,0)).xy);
		#if defined(TCP2_OUTLINE_CONST_SIZE)
			float2 outlineWidth = (_OutlineWidth * output.pos.w) / (_ScreenParams.xy / 2.0);
			output.pos.xy += clipNormals.xy * outlineWidth;
		#elif defined(TCP2_OUTLINE_MIN_SIZE)
			float screenRatio = _ScreenParams.x / _ScreenParams.y;
			float2 outlineWidth = max(
				(_OutlineMinWidth * output.pos.w) / (_ScreenParams.xy / 2.0),
				(_OutlineWidth / 100) * float2(1.0, screenRatio)
			);
			output.pos.xy += clipNormals.xy * outlineWidth;
		#elif defined(TCP2_OUTLINE_MIN_MAX_SIZE)
			float screenRatio = _ScreenParams.x / _ScreenParams.y;
			float2 outlineWidth = max(
				(_OutlineMinWidth * output.pos.w) / (_ScreenParams.xy / 2.0),
		        (_OutlineWidth / 100) * float2(1.0, screenRatio)
		    );
			outlineWidth = min(
				(_OutlineMaxWidth * output.pos.w) / (_ScreenParams.xy / 2.0),
		        outlineWidth
		    );
			output.pos.xy += clipNormals.xy * outlineWidth;
		#else
			float screenRatio = _ScreenParams.x / _ScreenParams.y;
			output.pos.xy += clipNormals.xy * (_OutlineWidth / 100) * float2(1.0, screenRatio);
		#endif
	#else
		input.vertex = input.vertex + float4(normal,0) * _OutlineWidth * 0.01;
	#endif

	output.vcolor.rgba = _OutlineColor.rgba;
	float4 clipPos = output.pos;

	#if defined(TCP2_OUTLINE_LIGHTING_ALL) && defined(_ADDITIONAL_LIGHTS_VERTEX)
		// Vertex lighting
		VertexNormalInputs vertexNormalInput = GetVertexNormalInputs(input.normal, input.tangent);
		output.vertexLights = VertexLighting(positionWS, vertexNormalInput.normalWS);
	#endif

	// World Position
	output.worldPos.xyz = positionWS;

	// Compute fog factor
	#if defined(TCP2_HYBRID_URP)
		output.worldPos.w = ComputeFogFactor(output.pos.z);
	#else
		UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(output, output.pos);
	#endif

	// Lighting & Texture
	#if defined(TCP2_OUTLINE_LIGHTING)
		output.normal = normalize(UnityObjectToWorldNormal(input.normal));
	#endif

	#if defined(TCP2_OUTLINE_TEXTURED_VERTEX)
		half4 outlineTexture = tex2Dlod(_BaseMap, float4(input.texcoord0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw, 0, _OutlineTextureLOD));
		output.vcolor *= outlineTexture;
	#endif

	#if defined(TCP2_OUTLINE_TEXTURED_FRAGMENT)
		output.texcoord0.xy = input.texcoord0.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
		output.texcoord0.zw = input.texcoord0.zw;
	#endif

	return output;
}

float4 fragment_outline (Varyings_Outline input) : SV_Target
{
	UNITY_SETUP_INSTANCE_ID(input);
	UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

	#if defined(LOD_FADE_CROSSFADE)
		const float dither = Dither4x4(input.pos.xy);
		const float ditherThreshold = unity_LODFade.x - CopySign(dither, unity_LODFade.x);
		clip(ditherThreshold);
	#endif

	#if defined(TCP2_OUTLINE_TEXTURED_FRAGMENT)
		// Manual mip map calculation so that we can apply a max value
		float2 dx = ddx(input.texcoord0.xy);
		float2 dy = ddy(input.texcoord0.xy);
		float delta = max(dot(dx, dx), dot(dy, dy));
		float mipMapLevel = max(0.5 * log2(delta), _OutlineTextureLOD);

		half4 albedo = tex2Dlod(_BaseMap, float4(input.texcoord0.xy, 0, mipMapLevel));
	#else
		half4 albedo = half4(1, 1, 1, 1);
	#endif

	// Output Color
	half4 outlineColor = half4(1, 1, 1, 1);

	#if defined(TCP2_OUTLINE_LIGHTING)

			#if URP_VERSION >= 14
				uint meshRenderingLayers = GetMeshRenderingLayer();
			#elif URP_VERSION >= 12
				uint meshRenderingLayers = GetMeshRenderingLightLayer();
			#endif

			float3 positionWS = input.worldPos.xyz;
			float3 normalWS = input.normal;
			#if defined(TCP2_HYBRID_URP)
				half3 viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);
			#else
				half3 viewDirWS = TCP2_SafeNormalize(UnityWorldSpaceViewDir(positionWS));
			#endif

		#if defined(TCP2_OUTLINE_LIGHTING_INDIRECT)
			// Indirect only
			outlineColor = half4(0, 0, 0, 1);
		#else
			// Main directional light
			#if defined(TCP2_HYBRID_URP)
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord = input.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					float4 shadowCoord = TransformWorldToShadowCoord(positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				half4 shadowMask = half4(1, 1, 1, 1); // no baked lighting for outlines

				#if URP_VERSION <= 7
					Light mainLight = GetMainLight(shadowCoord);
				#else
					Light mainLight = GetMainLight(shadowCoord, positionWS, shadowMask);
				#endif

				#if defined(_SCREEN_SPACE_OCCLUSION)
					float2 normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.pos);
					AmbientOcclusionFactor aoFactor = GetScreenSpaceAmbientOcclusion(normalizedScreenSpaceUV);
					mainLight.color *= aoFactor.directAmbientOcclusion;
				#endif

				#if URP_VERSION >= 12
					half3 lightDir = half3(0, 1, 0);
					half3 lightColor = half3(0, 0, 0);
					#if (URP_VERSION >= 14 && defined(_LIGHT_LAYERS)) || URP_VERSION <= 12
						if (IsMatchingLightLayer(mainLight.layerMask, meshRenderingLayers))
					#endif
					{
						lightDir = mainLight.direction;
						lightColor = mainLight.color.rgb;
					}
				#else
					half3 lightDir = mainLight.direction;
					half3 lightColor = mainLight.color.rgb;
				#endif
				half atten = mainLight.shadowAttenuation * mainLight.distanceAttenuation;
			#else
				half3 lightDir = normalize(UnityWorldSpaceLightDir(positionWS));
				half3 lightColor = _LightColor0.rgb;

				#if defined(SHADOW_CASTER_PASS)
					half atten = 1.0;
				#else
					TCP2_LIGHT_ATTENUATION(input, positionWS)
					#if defined(_RECEIVE_SHADOWS_OFF)
						half atten = attenuation;
					#else
						half atten = shadow * attenuation;
					#endif
				#endif
			#endif

			half ndl = dot(normalWS, lightDir);
			half ndlWrapped = ndl * 0.5 + 0.5;

			// Calculate ramp
			half3 ramp = CalculateRamp(ndlWrapped);

			// Apply attenuation
			ramp *= atten;

			#if defined(TCP2_OUTLINE_TEXTURED_FRAGMENT) && defined(TCP2_SHADOW_TEXTURE)
				half4 shadowAlbedo = tex2Dlod(_BaseMap, float4(input.texcoord0.xy, 0, mipMapLevel));
				albedo = lerp(shadowAlbedo, albedo, ramp.x);
			#endif

			// Highlight/shadow colors
			ramp = lerp(_SColor.rgb, _HColor.rgb, ramp);

			// Apply ramp
			outlineColor.rgb *= lerp(half3(1,1,1), ramp, _DirectIntensityOutline) * lightColor;
		#endif

	#endif

	// Apply albedo
	outlineColor.rgb *= albedo.rgb;

	#if defined(TCP2_OUTLINE_LIGHTING)
		half occlusion = 1.0;

		// Additional lights loop
		#if defined(TCP2_HYBRID_URP) && defined(TCP2_OUTLINE_LIGHTING_ALL) && defined(_ADDITIONAL_LIGHTS)
			uint pixelLightCount = GetAdditionalLightsCount();

			#if URP_VERSION >= 12
				#if USE_FORWARD_PLUS
					// Additional directional lights in Forward+
					for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
					{
						FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

						Light light = GetAdditionalLight(lightIndex, positionWS, shadowMask);

						#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							ProcessAdditionalLight(light, normalWS.xyz, albedo.rgb, outlineColor.rgb, _DirectIntensityOutline
								#if defined(_SCREEN_SPACE_OCCLUSION)
									, aoFactor
								#endif
							);
						}
					}

					// Data with dummy struct used in Forward+ macro (LIGHT_LOOP_BEGIN)
					#if !defined(_SCREEN_SPACE_OCCLUSION)
						float2 normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.pos);
					#endif
					InputDataForwardPlusDummy inputData;
					inputData.normalizedScreenSpaceUV = normalizedScreenSpaceUV;
					inputData.positionWS = positionWS;
				#endif

				LIGHT_LOOP_BEGIN(pixelLightCount)
			#else
				for (uint lightIndex = 0u; lightIndex < pixelLightCount; ++lightIndex)
				{
			#endif

			#if URP_VERSION <= 7
					Light light = GetAdditionalLight(lightIndex, positionWS);
			#else
					Light light = GetAdditionalLight(lightIndex, positionWS, shadowMask);
			#endif

			#if (URP_VERSION >= 12 && URP_VERSION < 14) || (URP_VERSION >= 14 && defined(_LIGHT_LAYERS))
				if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
			#endif
				{
					ProcessAdditionalLight(light, normalWS.xyz, albedo.rgb, outlineColor.rgb, _DirectIntensityOutline
						#if defined(_SCREEN_SPACE_OCCLUSION)
							, aoFactor
						#endif
					);
				}
			#if URP_VERSION >= 12
				LIGHT_LOOP_END
			#else
				}
			#endif
		#endif

		#if defined(TCP2_OUTLINE_LIGHTING_ALL) && defined(_ADDITIONAL_LIGHTS_VERTEX)
			outlineColor.rgb += input.vertexLights * albedo.rgb;
		#endif

		// Apply ambient/indirect lighting
		#if defined(TCP2_HYBRID_URP)

			#if defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2)
				// Adaptive Probe Volumes APV
				half3 bakedGI = SampleProbeVolumePixel(0.0, positionWS, normalWS, viewDirWS, input.pos.xy);
			#else
				// Sample SH fully per-pixel
				half3 bakedGI = SampleSH(_SingleIndirectColor > 0 ? viewDirWS : normalWS);
			#endif
			half3 indirectDiffuse = bakedGI * occlusion * albedo.rgb * _IndirectIntensityOutline;
			outlineColor.rgb += indirectDiffuse;
		#else
			half3 shNormal = (_SingleIndirectColor > 0) ? viewDirWS : normalWS;
			half3 bakedGI = ShadeSHPerPixel(shNormal, half3(0,0,0), positionWS);
			half3 indirectDiffuse = bakedGI * occlusion * albedo.rgb * _IndirectIntensityOutline;
			outlineColor.rgb += indirectDiffuse;
		#endif
	#endif

	outlineColor.rgba *= input.vcolor.rgba;

	// Fog
	#if defined(TCP2_HYBRID_URP)
		outlineColor.rgb = MixFog(outlineColor.rgb, input.worldPos.w);
	#else
		UNITY_EXTRACT_FOG_FROM_WORLD_POS(input);
		UNITY_APPLY_FOG(_unity_fogCoord, outlineColor.rgb);
	#endif

	return outlineColor;
}