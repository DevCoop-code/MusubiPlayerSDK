//
//  MusubiPlayerViewController.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/09.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

public class MusubiPlayerViewController: UIViewController {

    // ViewController를 인스턴스화 하기 위해 init() 함수를 호출
    public init() {
        super.init(nibName: "MusubiPlayerViewController", bundle: Bundle(for: MusubiPlayerViewController.self))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Property
    @IBOutlet weak var musubiPlayerView: UIView!
    @IBOutlet weak var musubiControllerGroup: UIView!
    @IBOutlet weak var musubiPlayPauseBtn: UIButton!
    @IBOutlet weak var musubiSeekbar: UISlider!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
}
