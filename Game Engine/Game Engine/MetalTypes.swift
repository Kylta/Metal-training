//
//  MetalTypes.swift
//  Game Engine
//
//  Created by Christophe Bugnon on 3/24/20.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

import simd

public typealias float2 = SIMD2<Float>
public typealias float3 = SIMD3<Float>
public typealias float4 = SIMD4<Float>

protocol Sizeable {
    static func size(_ count: Int) -> Int
    static func stride(_ count: Int) -> Int
}

extension Sizeable {
    static func size() -> Int {
        return MemoryLayout<Self>.size
    }
    
    static func stride() -> Int {
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count: Int) -> Int {
        return MemoryLayout<Self>.size * count
    }
    
    static func stride(_ count: Int) -> Int {
        return MemoryLayout<Self>.stride * count
    }
}


struct Vertex {
    var position: float3
    var color: float4
}

extension Vertex: Sizeable {}

extension float3: Sizeable {}
