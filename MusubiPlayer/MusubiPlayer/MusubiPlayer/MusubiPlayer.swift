//
//  MusubiPlayer.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/09.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit
import Foundation
import MetalKit
import AVFoundation
import MobileCoreServices

var ONE_FRAME_DURATION: Double {
    get {
        0.03
    }
}

enum mediaType {
    case local
    case hls
    case dash
}

class MusubiPlayer:NSObject, AVPlayerItemOutputPullDelegate {
    var device_: MTLDevice?
    var metalLayer_: CAMetalLayer?
    var pipelineState_: MTLRenderPipelineState?
    var commandQueue_: MTLCommandQueue?
    
    var avPlayer_: AVPlayer?
    var videoOutput_: AVPlayerItemVideoOutput?
    var m_type_: mediaType?
    
    var videoOutputQueue_: DispatchQueue?
    var timer_: CADisplayLink?
    var lastFrameTimestamp_: CFTimeInterval?
    
    var mediaContentPath_: String?
    
    var currentPlayTime_: CMTime?
    var totalPlayTime_: CMTime?
    
    var musubiDelegate: MusubiDelegate?
    
    init(_ videoPlayerView: UIView) {
        super.init()
        
        lastFrameTimestamp_ = 0.0
        
        device_ = MTLCreateSystemDefaultDevice()
        metalLayer_ = CAMetalLayer()
        
        if let metalDevice = device_, let metalLayer = metalLayer_ {
            metalLayer.device = metalDevice
            metalLayer.pixelFormat = .bgra8Unorm
            metalLayer.framebufferOnly = true
            metalLayer.frame = videoPlayerView.layer.frame
            videoPlayerView.layer.addSublayer(metalLayer)
            
            let defaultLibrary = metalDevice.makeDefaultLibrary()
            let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
            let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
            
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = vertexProgram
            pipelineStateDescriptor.fragmentFunction = fragmentProgram
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
            pipelineState_ = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
            commandQueue_ = metalDevice.makeCommandQueue()
            
        }
        
        timer_ = CADisplayLink.init(target: self, selector: #selector(newFrame))
        timer_?.add(to: .main, forMode: .default)

        // Setup AVPlayerItemVideoOutput with the required pixelbuffer attributes
        var pixelBufferAttributes: NSDictionary = [kCVPixelBufferMetalCompatibilityKey:true, kCVPixelBufferPixelFormatTypeKey:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        videoOutput_ = AVPlayerItemVideoOutput.init(pixelBufferAttributes: pixelBufferAttributes as! [String: Any])
        videoOutput_?.setDelegate(self, queue: videoOutputQueue_)
    }
    
    @objc func newFrame(displayLink: CADisplayLink) {
        /*
         The Callback gets called once every vsync
         Using the display link's timestamp and duration we can compute the next time the screen will be refreshed, and copy the pixel buffer for that time.
         This pixelbuffer can then be processed and later rendered on screen
         */
        var outputItemTime: CMTime = .invalid
        
        // Calculate the nextVSync time which is when the screen will be refreshed next
        let nextVSync: CFTimeInterval = (displayLink.timestamp + displayLink.duration)
        
        if let videoOutput = videoOutput_ {
            outputItemTime = videoOutput.itemTime(forHostTime: nextVSync)
            
            var pixelBuffer: CVPixelBuffer?
            if videoOutput.hasNewPixelBuffer(forItemTime: outputItemTime) {
                pixelBuffer = videoOutput.copyPixelBuffer(forItemTime: outputItemTime, itemTimeForDisplay: nil)
            }
            
            if 0.0 == lastFrameTimestamp_ {
                lastFrameTimestamp_ = displayLink.timestamp
            }
            
            if let lastFrameTimestamp = lastFrameTimestamp_ {
                var elapsed: TimeInterval = displayLink.timestamp - lastFrameTimestamp
                lastFrameTimestamp_ = displayLink.timestamp
                
                // AutoRelease
                let drawable: CAMetalDrawable? = metalLayer_?.nextDrawable()
                if let pixelBufferData = pixelBuffer, let drawableData = drawable {
                    musubiDelegate?.renderObject(drawable: drawableData, pixelBuffer: pixelBufferData)
                }
            }
        }
    }
}
