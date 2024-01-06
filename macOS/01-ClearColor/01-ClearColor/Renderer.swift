//
//  Renderer.swift
//  01-ClearColor
//
//  Created by Vishwajeet Mane on 05/01/24.
//

import Metal
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
    init?(mtkView: MTKView) {
        device = mtkView.device!
        commandQueue = device.makeCommandQueue()!
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
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
