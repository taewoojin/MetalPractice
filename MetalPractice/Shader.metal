//
//  Shader.metal
//  MetalPractice
//
//  Created by 태우 on 2020/05/15.
//  Copyright © 2020 taewoo. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


vertex float4 vertexPassThrough(const device packed_float2* vertices [[ buffer(0) ]],
                           unsigned int vertexId [[ vertex_id ]])
{
  return float4(vertices[vertexId], 0.0, 1.0);
}


fragment half4 fragmentPassThrough() {
  return half4(0, 1, 0, 1);
}
