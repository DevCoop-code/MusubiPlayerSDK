//
//  RawPlayerViewController.swift
//  MusubiPlayerDemo
//
//  Created by HanGyo Jeong on 2020/11/15.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

class RawPlayerViewController: UIViewController {

    @IBOutlet weak var videoPreview: UIView!
    
    @IBOutlet weak var playpauseBtn: UIButton!
    
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    @IBOutlet weak var seekBar: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
}
