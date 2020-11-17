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
        
        player = MusubiPlayer(videoPreview)
        if let mediaURL = videoURL {
            player?.open(mediaURL, mediaType: .hls)
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

extension RawPlayerViewController: MusubiCallback {
    
}
