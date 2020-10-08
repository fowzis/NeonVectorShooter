// Pixel shader extracts the brighter areas of an image.
// This is the first step in applying a bloom postprocess.

#if OPENGL
#define VS_SHADERMODEL vs_3_0
#define PS_SHADERMODEL ps_3_0
#else
#define VS_SHADERMODEL vs_4_0_level_9_1
#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

sampler TextureSampler : register(s0);

float BloomThreshold;

// This function signature does not work properly in DirectX, while work good with Open GL
//float4 PixelShaderFunction(float2 texCoord : TEXCOORD0) : COLOR0
float4 PixelShaderFunction(float4 position : POSITION0, float4 c : COLOR0, float2 texCoord : TEXCOORD0) : COLOR
{
    // Look up the original image color.
    float4 color = tex2D(TextureSampler, texCoord);

    // Adjust it to keep only values brighter than the specified threshold.
    return saturate((color - BloomThreshold) / (1 - BloomThreshold));
}


technique BloomExtract
{
    pass Pass1
    {
        PixelShader = compile PS_SHADERMODEL PixelShaderFunction();
    }
}