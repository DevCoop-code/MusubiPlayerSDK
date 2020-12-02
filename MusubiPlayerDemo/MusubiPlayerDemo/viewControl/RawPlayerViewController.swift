//
//  RawPlayerViewController.swift
//  MusubiPlayerDemo
//
//  Created by HanGyo Jeong on 2020/11/15.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit
import MusubiPlayer

enum seekBehavior {
    case none;
    case seeking;
    case seekEnd;
}

class RawPlayerViewController: UIViewController {

    @IBOutlet weak var videoPreview: UIView!
    
    @IBOutlet weak var playpauseBtn: UIButton!
    
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var player: MusubiPlayer?
    
    var videoURL: String?
    var currentPlayerTime: Float = 0.0
    
    var userAction: seekBehavior = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSLog("videoPreview Frame: \(videoPreview.frame)")
        
//        if #available(iOS 11.0, *) {
//            let window = UIApplication.shared.keyWindow
//            let topPadding = window?.safeAreaInsets.top
//            let bottomPadding = window?.safeAreaInsets.bottom
//            let leadingPadding = window?.safeAreaInsets.left
//            let trailingPadding = window?.safeAreaInsets.right
//
//            NSLog("\(topPadding), \(bottomPadding), \(leadingPadding), \(trailingPadding)")
//        }
        
        seekBar.minimumValue = 0.0
        
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(videoPreview.bounds)")
        
        player = MusubiPlayer(videoPreview)
        print("\(videoPreview.bounds)")
        if let mediaURL = videoURL {
            player?.musubiDelegate = self
            player?.open(mediaURL, mediaType: .hls)
            player?.setThumbnailSeekbar(seekBar)
            player?.setExternalSubtitle("/Function_b.smi", SubtitleType(2))
            player?.start()
            
            playpauseBtn.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.close()
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if let musubiPlayer = player {
            switch musubiPlayer.getPlayerState() {
            case .play:
                musubiPlayer.pause()
                playpauseBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
                break
            case .pause:
                musubiPlayer.start()
                playpauseBtn.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
                break
            default:
                
                break
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func seekBarTouchDown(_ sender: Any) {
        userAction = .seeking
    }

    @IBAction func seekBarTouchUp(_ sender: Any) {
        let seekbar = sender as! UISlider
        if userAction == .seeking {
            if let player = player {
                player.seek(seekbar.value)
                
                currentPlayerTime = seekbar.value
                userAction = .seekEnd
            }
        }
    }
}

extension RawPlayerViewController: MusubiDelegate {
    func renderObject(drawable: CAMetalDrawable, pixelBuffer: CVPixelBuffer) {
        // Can see the video pixelbuffer
    }
    
    func currentTime(time: Float64) {
        let curTime = Int(time)
        elapsedTime.text = convertTimeFormat(time: curTime)
        
        if userAction != seekBehavior.seeking {
            if userAction == .seekEnd {
                if !(Double(currentPlayerTime) - time > 1.0 || Double(currentPlayerTime) - time < -1.0) {
                    seekBar.value = Float(curTime.doubleValue)
                    userAction = .none
                }
            } else {
                seekBar.value = Float(curTime.doubleValue)
            }
        }
    }
    
    func totalTime(time: Float64) {
        let curTime = Int(time)
        totalTime.text = convertTimeFormat(time: curTime)
        
        seekBar.maximumValue = Float(curTime.doubleValue)
    }
    
    func onSubtitleData(startTime: Int, endTime: Int, text: String) {
        NSLog("TextRender: \(text)")
    
        subtitleLabel.text = text
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
