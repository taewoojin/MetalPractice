//
//  ViewController.swift
//  MetalPractice
//
//  Created by 태우 on 2020/05/15.
//  Copyright © 2020 taewoo. All rights reserved.
//

import UIKit
import MetalKit


class ViewController: UIViewController {
  
  var device: MTLDevice!
  var metalLayer: CAMetalLayer!
  var vertexBuffer: MTLBuffer!
  var pipelineState: MTLRenderPipelineState!
  var commandQueue: MTLCommandQueue!
  
  let vertexData: [Float] = [
    0, 1,
    -1, -1,
    1, -1
  ]
  
//  let vertexData: [Float] = [
//    0.5, -0.5,
//    -0.5, -0.5,
//    -0.5,  0.5,
//
//    0.5,  0.5,
//    0.5, -0.5,
//    -0.5,  0.5
//  ]
  
//    let vertexData: [Float] = [
//      0, -0.5,
//      -0.5, -0.5,
//      -0.5,  0,
//
//      0, 0.5,
//      0.5, 0.5,
//      0.5,  0,
//    ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    device = MTLCreateSystemDefaultDevice()
    commandQueue = device.makeCommandQueue()
    
    initMatalLayer()
    createVertexBuffer()
    createRenderPipeline()
    
    
    guard let drawable = metalLayer.nextDrawable() else { return }
    
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .clear
    renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
    
//    renderPassDescriptor.depthAttachment.texture = self.depthTexture;
//    renderPassDescriptor.depthAttachment.loadAction = .clear
//    renderPassDescriptor.depthAttachment.storeAction = .store
//    renderPassDescriptor.depthAttachment.clearDepth = 1
    
    
    let commandBuffer = commandQueue.makeCommandBuffer()!
    let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
    commandEncoder?.setRenderPipelineState(pipelineState)
    commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexData.count)
    
    commandEncoder?.endEncoding()
    
    commandBuffer.present(drawable)
    commandBuffer.commit()
    
  }
  
  func initMatalLayer() {
    metalLayer = CAMetalLayer()
    metalLayer.device = self.device
    metalLayer.pixelFormat = .bgra8Unorm
    metalLayer.framebufferOnly = true
    metalLayer.frame = view.layer.frame
    view.layer.addSublayer(metalLayer)
  }
  
  func createVertexBuffer() {
    let vertexDataSize = vertexData.count * MemoryLayout<Float>.size
    vertexBuffer = device.makeBuffer(bytes: vertexData,
                                     length: vertexDataSize,
                                     options: [])
  }
  
  func createRenderPipeline() {
    let defaultLibrary = device.makeDefaultLibrary()
    let vertexFunction = defaultLibrary?.makeFunction(name: "vertexPassThrough")
    let fragmentFunction = defaultLibrary?.makeFunction(name: "fragmentPassThrough")
    
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    
    pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
  }
  
}

