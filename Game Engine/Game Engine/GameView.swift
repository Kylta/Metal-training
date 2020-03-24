//
//  GameView.swift
//  Game Engine
//
//  Created by Christophe Bugnon on 3/24/20.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

import MetalKit

class GameView: MTKView {
    
    private var commandQueue: MTLCommandQueue!
    private var renderPipelineState: MTLRenderPipelineState!
    
    var vertices: [Vertex] = []
    
    var vertexBuffer: MTLBuffer!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        self.clearColor = MTLClearColorMake(0.43, 0.73, 0.35, 1.0)
        self.colorPixelFormat = .bgra8Unorm                             // default: bgra8Unorm
        self.commandQueue = device?.makeCommandQueue()
        createRenderPipelineState()
        createVertices()
        createBuffers()
    }
    
    func createVertices() {
        self.vertices = [
            Vertex(position: float3(0, 1, 0), color: float4(1, 0, 0, 1)),       // Top midle    red
            Vertex(position: float3(-1, -1, 0), color: float4(0, 1, 0, 1)),     // Bot left     green
            Vertex(position: float3(1, -1, 0), color: float4(0, 0, 1, 1))       // Bot right    blue
        ]
    }
    
    func createBuffers() {
        self.vertexBuffer = device?.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
    }
    
    func createRenderPipelineState() {
        let library = device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_shader")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        // Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        // Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = float3.size()
        
        vertexDescriptor.layouts[0].stride = Vertex.stride()
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        self.renderPipelineState = try! device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
    }
        
    override func draw(_ dirtyRect: NSRect) {
        guard let drawable = self.currentDrawable, let renderPassDescriptor = self.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderCommandEncoder?.setRenderPipelineState(self.renderPipelineState)
        
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
