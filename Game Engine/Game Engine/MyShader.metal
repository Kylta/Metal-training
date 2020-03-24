//
//  MyShader.metal
//  Game Engine
//
//  Created by Christophe Bugnon on 3/24/20.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex_shader() {
    return float4(1);
}

fragment half4 basic_fragment_shader() {
    return half4(1);
}
