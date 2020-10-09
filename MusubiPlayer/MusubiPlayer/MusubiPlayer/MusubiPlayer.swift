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

enum mediaType {
    case local
    case hls
    case dash
}

class MusubiPlayer: NSObject {
    var device: MTLDevice?
    var metalLayer: CAMetalLayer?
    var pipelineState: MTLRenderPipelineState?
    var commandQueue: MTLCommandQueue?
    var avPlayer: AVPlayer?
}
