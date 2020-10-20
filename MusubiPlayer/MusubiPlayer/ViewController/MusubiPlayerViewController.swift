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

enum userBehaviour {
    case none;
    case seeking;
    case seekEnd;
}

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
    
    var userAction: userBehaviour = .none
    var currentPlayerTime: Float = 0.0
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        musubiSeekbar.minimumValue = 0.0
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
        
        // When play automatically
        musubiPlayer?.start()
        self.musubiPlayPauseBtn.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    // MARK: - UI Event Action
    @IBAction func playPauseAction(_ sender: Any) {
        NSLog("playpause action")
        
        if let player = musubiPlayer {
            switch player.getPlayerState() {
            case .play:
                player.pause()
                self.musubiPlayPauseBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
                break
            case .pause:
                player.start()
                self.musubiPlayPauseBtn.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
                break
            default:
                NSLog("Player State is not suitable")
                break
            }
        }
    }
    
    @IBAction func seekbarValueChanged(_ sender: Any) {
//        let seekbar = sender as! UISlider
//        NSLog("Seek value: %f", seekbar.value)
//
//        if let player = musubiPlayer {
//            player.seek(seekbar.value)
//
//            musubiSeekbar.value = seekbar.value
//        }
    }
    
    @IBAction func seekBarTouchDown(_ sender: Any) {
        NSLog("Touch Down")
        userAction = .seeking
    }
    
    @IBAction func seekBarTouchUp(_ sender: Any) {
        let seekbar = sender as! UISlider
        NSLog("Touch Up")
        if userAction == .seeking {
            if let player = musubiPlayer {
                player.seek(seekbar.value)
                
//                NSLog("=====Seekvar value: %d", seekbar.value)
                currentPlayerTime = seekbar.value
//                musubiSeekbar.value = seekbar.value
                userAction = .seekEnd
            }
        }
    }
}

extension MusubiPlayerViewController: MusubiDelegate {
    func renderObject(drawable: CAMetalDrawable, pixelBuffer: CVPixelBuffer) {
        // Add the code for rendering video
    }
    
    func currentTime(time: Float64) {
        let curTime = Int(time)
        elapsedTimeLabel.text = /*String(describing: curTime)*/ convertTimeFormat(time: curTime)
        
        if userAction != userBehaviour.seeking {
            if userAction == .seekEnd {
                if !(Double(currentPlayerTime) - time > 1.0 || Double(currentPlayerTime) - time < -1.0) {
                    musubiSeekbar.value = Float(curTime.doubleValue)
                    userAction = .none
                }
            }else {
                musubiSeekbar.value = Float(curTime.doubleValue)
            }
        }
    }
    
    func totalTime(time: Float64) {
        let curTime = Int(time)
        remainTimeLabel.text = /*String(describing: time)*/ convertTimeFormat(time: curTime)
        
        // Set the Seek bar maximum value
        musubiSeekbar.maximumValue = Float(curTime.doubleValue)
    }
    
    func convertTimeFormat(time: Int) -> String {
        var result: String
        var hour: Int = 0
        var minute: Int = 0
        var second: Int = 0
        
        hour = time / 3600
        
        let extraMinutes = time % 3600
        
        minute = extraMinutes / 60
        second = extraMinutes % 60
        
        if hour != 0 {
            if second >= 0 && second < 10 && minute > 9{
                result = "\(hour):\(minute):0\(second)"
            } else if second >= 0 && second < 10 && minute >= 0 && minute < 10 {
                result = "\(hour):0\(minute):0\(second)"
            } else if minute >= 0 && minute < 10 && second > 9 {
                result = "\(hour):0\(minute):\(second)"
            } else {
                 result = "\(hour):\(minute):\(second)"
            }
        } else {
            if second >= 0 && second < 10 && minute > 9{
                result = "\(hour):\(minute):0\(second)"
            } else if second >= 0 && second < 10 && minute >= 0 && minute < 10 {
                result = "0\(minute):0\(second)"
            } else if minute >= 0 && minute < 10 && second > 9 {
                result = "0\(minute):\(second)"
            } else {
                 result = "\(minute):\(second)"
            }
        }
        
        return result
    }
}

extension Int {
    var doubleValue: Double {
        return Double(self)
    }
}
