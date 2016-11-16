#ifndef UNITY_MATERIAL_INCLUDED
#define UNITY_MATERIAL_INCLUDED

#include "Color.hlsl"
#include "Packing.hlsl"
#include "BSDF.hlsl"
#include "Debug.hlsl"
#include "GeometricTools.hlsl"
#include "CommonMaterial.hlsl"
#include "CommonLighting.hlsl"
#include "EntityLighting.hlsl"

//-----------------------------------------------------------------------------
// BuiltinData
//-----------------------------------------------------------------------------

#include "Builtin/BuiltinData.hlsl"

//-----------------------------------------------------------------------------
// Material definition
//-----------------------------------------------------------------------------

// Here we include all the different lighting model supported by the renderloop based on define done in .shader
// Only one deferred layout is allowed for a HDRenderLoop, this will be detect by the redefinition of GBUFFERMATERIAL_COUNT
// If GBUFFERMATERIAL_COUNT is define two time, the shaders will not compile
#ifdef UNITY_MATERIAL_LIT
#include "Lit/Lit.hlsl"
#elif defined(UNITY_MATERIAL_UNLIT)
#include "Unlit/Unlit.hlsl"
#endif

//-----------------------------------------------------------------------------
// Define for GBuffer management
//-----------------------------------------------------------------------------

#ifdef GBUFFERMATERIAL_COUNT

#if GBUFFERMATERIAL_COUNT == 2

#define OUTPUT_GBUFFER(NAME)                            \
        out GBufferType0 MERGE_NAME(NAME, 0) : SV_Target0,    \
        out GBufferType1 MERGE_NAME(NAME, 1) : SV_Target1

#define DECLARE_GBUFFER_TEXTURE(NAME)   \
        TEXTURE2D(MERGE_NAME(NAME, 0));  \
        TEXTURE2D(MERGE_NAME(NAME, 1));

#define FETCH_GBUFFER(NAME, TEX, UV)                                        \
        GBufferType0 MERGE_NAME(NAME, 0) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 0), uint3(UV, 0)); \
        GBufferType1 MERGE_NAME(NAME, 1) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 1), uint3(UV, 0));

#define ENCODE_INTO_GBUFFER(SURFACE_DATA, BAKE_DIFFUSE_LIGHTING, NAME) EncodeIntoGBuffer(SURFACE_DATA, BAKE_DIFFUSE_LIGHTING, MERGE_NAME(NAME,0), MERGE_NAME(NAME,1))
#define DECODE_FROM_GBUFFER(NAME, BSDF_DATA, BAKE_DIFFUSE_LIGHTING) DecodeFromGBuffer(MERGE_NAME(NAME,0), MERGE_NAME(NAME,1), BSDF_DATA, BAKE_DIFFUSE_LIGHTING)

#if SHADEROPTIONS_VELOCITY_IN_GBUFFER
#define OUTPUT_GBUFFER_VELOCITY(NAME) ,out float4 NAME : SV_Target2
#endif

#elif GBUFFERMATERIAL_COUNT == 3

#define OUTPUT_GBUFFER(NAME)                            \
        out GBufferType0 MERGE_NAME(NAME, 0) : SV_Target0,    \
        out GBufferType1 MERGE_NAME(NAME, 1) : SV_Target1,    \
        out GBufferType2 MERGE_NAME(NAME, 2) : SV_Target2

#define DECLARE_GBUFFER_TEXTURE(NAME)   \
        TEXTURE2D(MERGE_NAME(NAME, 0));  \
        TEXTURE2D(MERGE_NAME(NAME, 1));  \
        TEXTURE2D(MERGE_NAME(NAME, 2));

#define FETCH_GBUFFER(NAME, TEX, UV)                                        \
        GBufferType0 MERGE_NAME(NAME, 0) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 0), uint3(UV, 0)); \
        GBufferType1 MERGE_NAME(NAME, 1) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 1), uint3(UV, 0)); \
        GBufferType2 MERGE_NAME(NAME, 2) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 2), uint3(UV, 0));

#define ENCODE_INTO_GBUFFER(SURFACE_DATA, BAKE_DIFFUSE_LIGHTING, NAME) EncodeIntoGBuffer(SURFACE_DATA, BAKE_DIFFUSE_LIGHTING, MERGE_NAME(NAME,0), MERGE_NAME(NAME,1), MERGE_NAME(NAME,2))
#define DECODE_FROM_GBUFFER(NAME, BSDF_DATA, BAKE_DIFFUSE_LIGHTING) DecodeFromGBuffer(MERGE_NAME(NAME,0), MERGE_NAME(NAME,1), MERGE_NAME(NAME,2), BSDF_DATA, BAKE_DIFFUSE_LIGHTING)

#if SHADEROPTIONS_VELOCITY_IN_GBUFFER
#define OUTPUT_GBUFFER_VELOCITY(NAME) ,out float4 NAME : SV_Target3
#endif

#elif GBUFFERMATERIAL_COUNT == 4

#define OUTPUT_GBUFFER(NAME)                            \
        out GBufferType0 MERGE_NAME(NAME, 0) : SV_Target0,    \
        out GBufferType1 MERGE_NAME(NAME, 1) : SV_Target1,    \
        out GBufferType2 MERGE_NAME(NAME, 2) : SV_Target2,    \
        out GBufferType3 MERGE_NAME(NAME, 3) : SV_Target3

#define DECLARE_GBUFFER_TEXTURE(NAME)   \
        TEXTURE2D(MERGE_NAME(NAME, 0));  \
        TEXTURE2D(MERGE_NAME(NAME, 1));  \
        TEXTURE2D(MERGE_NAME(NAME, 2));  \
        TEXTURE2D(MERGE_NAME(NAME, 3));

#define FETCH_GBUFFER(NAME, TEX, UV)                                        \
        GBufferType0 MERGE_NAME(NAME, 0) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 0), uint3(UV, 0)); \
        GBufferType1 MERGE_NAME(NAME, 1) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 1), uint3(UV, 0)); \
        GBufferType2 MERGE_NAME(NAME, 2) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 2), uint3(UV, 0)); \
        GBufferType3 MERGE_NAME(NAME, 3) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 3), uint3(UV, 0));

#define ENCODE_INTO_GBUFFER(SURFACE_DATA, BAKE_DIFFUSE_LIGHTING, NAME) EncodeIntoGBuffer(SURFACE_DATA, BAKE_DIFFUSE_LIGHTING, MERGE_NAME(NAME, 0), MERGE_NAME(NAME, 1), MERGE_NAME(NAME, 2), MERGE_NAME(NAME, 3))
#define DECODE_FROM_GBUFFER(NAME, BSDF_DATA, BAKE_DIFFUSE_LIGHTING) DecodeFromGBuffer(MERGE_NAME(NAME, 0), MERGE_NAME(NAME, 1), MERGE_NAME(NAME, 2), MERGE_NAME(NAME, 3), BSDF_DATA, BAKE_DIFFUSE_LIGHTING)

#if SHADEROPTIONS_VELOCITY_IN_GBUFFER
#define OUTPUT_GBUFFER_VELOCITY(NAME) ,out float4 NAME : SV_Target4
#endif

#elif GBUFFERMATERIAL_COUNT == 5

#define OUTPUT_GBUFFER(NAME)                            \
        out GBufferType0 MERGE_NAME(NAME, 0) : SV_Target0,    \
        out GBufferType1 MERGE_NAME(NAME, 1) : SV_Target1,    \
        out GBufferType2 MERGE_NAME(NAME, 2) : SV_Target2,    \
        out GBufferType3 MERGE_NAME(NAME, 3) : SV_Target3,    \
        out GBufferType4 MERGE_NAME(NAME, 4) : SV_Target4

#define DECLARE_GBUFFER_TEXTURE(NAME)   \
        TEXTURE2D(MERGE_NAME(NAME, 0));  \
        TEXTURE2D(MERGE_NAME(NAME, 1));  \
        TEXTURE2D(MERGE_NAME(NAME, 2));  \
        TEXTURE2D(MERGE_NAME(NAME, 3));  \
        TEXTURE2D(MERGE_NAME(NAME, 4));

#define FETCH_GBUFFER(NAME, TEX, UV)                                        \
        GBufferType0 MERGE_NAME(NAME, 0) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 0), uint3(UV, 0)); \
        GBufferType1 MERGE_NAME(NAME, 1) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 1), uint3(UV, 0)); \
        GBufferType2 MERGE_NAME(NAME, 2) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 2), uint3(UV, 0)); \
        GBufferType3 MERGE_NAME(NAME, 3) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 3), uint3(UV, 0)); \
        GBufferType4 MERGE_NAME(NAME, 4) = LOAD_TEXTURE2D(MERGE_NAME(TEX, 4), uint3(UV, 0));

#define ENCODE_INTO_GBUFFER(SURFACE_DATA, BAKE_DIFFUSE_LIGHTING, NAME) EncodeIntoGBuffer(SURFACE_DATA, BAKE_DIFFUSE_LIGHTING, MERGE_NAME(NAME, 0), MERGE_NAME(NAME, 1), MERGE_NAME(NAME, 2), MERGE_NAME(NAME, 3), MERGE_NAME(NAME, 4))
#define DECODE_FROM_GBUFFER(NAME, BSDF_DATA, BAKE_DIFFUSE_LIGHTING) DecodeFromGBuffer(MERGE_NAME(NAME, 0), MERGE_NAME(NAME, 1), MERGE_NAME(NAME, 2), MERGE_NAME(NAME, 3), MERGE_NAME(NAME, 4), BSDF_DATA, BAKE_DIFFUSE_LIGHTING)

#if SHADEROPTIONS_VELOCITY_IN_GBUFFER
#define OUTPUT_GBUFFER_VELOCITY(NAME) ,out float4 NAME : SV_Target5
#endif

#endif

#if SHADEROPTIONS_VELOCITY_IN_GBUFFER
#define ENCODE_VELOCITY_INTO_GBUFFER(VELOCITY, NAME) EncodeVelocity(VELOCITY, NAME)
#else
#define OUTPUT_GBUFFER_VELOCITY(NAME)
#define ENCODE_VELOCITY_INTO_GBUFFER(VELOCITY, NAME)
#endif

#endif // #ifdef GBUFFERMATERIAL_COUNT

#endif // UNITY_MATERIAL_INCLUDED