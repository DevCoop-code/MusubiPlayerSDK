//
//  MusubiProtocol.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/09.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

protocol MusubiDelegate {
    func renderObject(drawable: CAMetalDrawable, pixelBuffer: CVPixelBuffer)
}
