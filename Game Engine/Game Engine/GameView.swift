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

    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        self.clearColor = MTLClearColorMake(0.43, 0.73, 0.35, 1.0)
        self.colorPixelFormat = .bgra8Unorm                             // default: bgra8Unorm
        self.commandQueue = device?.makeCommandQueue()
        createRenderPipelineState()
        
    }
    
    func createRenderPipelineState() {
        let library = device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_shader")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        self.renderPipelineState = try! device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let drawable = self.currentDrawable, let renderPassDescriptor = self.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderCommandEncoder?.setRenderPipelineState(self.renderPipelineState)
        
        // Send info to renderCommandEncoder
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
