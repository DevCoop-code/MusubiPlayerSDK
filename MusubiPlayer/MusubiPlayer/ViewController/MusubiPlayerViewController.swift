//
//  MusubiPlayerViewController.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/09.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit
import MetalKit
import Metal
import Foundation

open class MusubiPlayerViewController: UIViewController {

    // ViewController를 인스턴스화 하기 위해 init() 함수를 호출
    public init() {
        super.init(nibName: "MusubiPlayerViewController", bundle: Bundle(for: MusubiPlayerViewController.self))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Property
    @IBOutlet weak var musubiControllerGroup: UIView!
    @IBOutlet weak var musubiPlayPauseBtn: UIButton!
    @IBOutlet weak var musubiSeekbar: UISlider!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    @IBOutlet weak var musubiPlayerview: MusubiPlayerView!
    
    var musubiPlayer: MusubiPlayer?
    
    open var mediaURL: String?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        if let mediaPath = mediaURL {
            NSLog("Media URL: %@", mediaPath)
            musubiPlayer = MusubiPlayer(musubiPlayerview)
            musubiPlayer?.open(mediaPath, mediaType: .hls)
            
            musubiPlayer?.musubiDelegate = self
        } else {
            
        }
        
        musubiPlayer?.start()
    }
}

extension MusubiPlayerViewController: MusubiDelegate {
    func renderObject(drawable: CAMetalDrawable, pixelBuffer: CVPixelBuffer) {
        // Add the code for rendering video
    }
    
    func currentTime(time: Float64) {
        var curTime = Int(time)
        elapsedTimeLabel.text = /*String(describing: curTime)*/ convertTimeFormat(time: curTime)
    }
    
    func totalTime(time: Float64) {
        var curTime = Int(time)
        remainTimeLabel.text = /*String(describing: time)*/ convertTimeFormat(time: curTime)
    }
    
    func convertTimeFormat(time: Int) -> String {
        var result: String
        var hour: Int = 0
        var minute: Int = 0
        var second: Int = 0
        
        hour = time / 3600
        
        var extraMinutes = time % 3600
        
        minute = extraMinutes / 60
        second = extraMinutes % 60
        
        if hour != 0 {
            result = "\(hour):\(minute):\(second)"
        } else {
            result = "\(minute):\(second)"
        }
        
        return result
    }
}
