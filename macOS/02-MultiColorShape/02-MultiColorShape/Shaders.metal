//
//  Shaders.metal
//  02-MultiColorShape
//
//  Created by Vishwajeet Mane on 06/01/24.
//

#include <metal_stdlib>
using namespace metal;

#include "ShaderDefinitions.h"

struct VertexOut {
    float4 color;
    float4 pos [[position]];
};

vertex VertexOut vertexShader(const device Vertex *vertexArray [[buffer((0))]], unsigned int vid [[vertex_id]]) {
    Vertex in = vertexArray[vid];
    
    VertexOut out;
    
    out.color = in.color;
    
    out.pos = float4(in.pos.x, in.pos.y, 0, 1);
    
    return out;
}

fragment float4 fragmentShader(VertexOut interpolated [[stage_in]]) {
    return interpolated.color;
}

