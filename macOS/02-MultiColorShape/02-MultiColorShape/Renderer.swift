//
//  Renderer.swift
//  01-ClearColor
//
//  Created by Vishwajeet Mane on 05/01/24.
//

import Foundation
import Metal
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    // Shared Memory Access
    let vertexBuffer: MTLBuffer
    
    init?(mtkView: MTKView) {
        device = mtkView.device!
        commandQueue = device.makeCommandQueue()!
        
        do {
            print("Inside")
            pipelineState = try Renderer.buildRenderPipelineWith(device: device, metalKitView: mtkView)
            print(pipelineState)
        } catch {
            print("Unable to compile render pipeline state: \(error)")
            return nil
        }
        
        let vertices = [
            Vertex(color: [1, 0, 0, 1], pos: [-1, -1]),
            Vertex(color: [0, 1, 0, 1], pos: [0, 1]),
            Vertex(color: [0, 0, 1, 0], pos: [1, -1])
        ]
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
        
    }
    
    class func buildRenderPipelineWith(device: MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer()
        else {
            return
        }
        
        guard let renderpassDescriptor = view.currentRenderPassDescriptor else { return }
        
        renderpassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.99, 0.81, 0.92, 1)
        
        // Convert to MTLRendererEncoder
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderpassDescriptor) else { return }
        
        // Tell Which Pipeline to be used
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // Which Vertex Buffer, One Vertex Buffer -> index = 0
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}

