//
//  RawPlayerViewController.swift
//  MusubiPlayerDemo
//
//  Created by HanGyo Jeong on 2020/11/15.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit
import MusubiPlayer

class RawPlayerViewController: UIViewController {

    @IBOutlet weak var videoPreview: UIView!
    
    @IBOutlet weak var playpauseBtn: UIButton!
    
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    @IBOutlet weak var seekBar: UISlider!
    
    var player: MusubiPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        player = MusubiPlayer(videoPreview)
        player?.open("https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8", mediaType: .hls)
        player?.start()
    }
}
