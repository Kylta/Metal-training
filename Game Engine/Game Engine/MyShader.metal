//
//  MyShader.metal
//  Game Engine
//
//  Created by Christophe Bugnon on 3/24/20.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex_shader(const device float3 *vertices [[ buffer(0) ]],
                                  uint vertexID [[ vertex_id ]]) {
    return float4(vertices[vertexID], 1);
}

fragment half4 basic_fragment_shader() {
    return half4(1);
}
