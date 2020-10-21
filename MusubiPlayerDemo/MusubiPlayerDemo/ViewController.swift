//
//  ViewController.swift
//  MusubiPlayerDemo
//
//  Created by HanGyo Jeong on 2020/10/09.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit
import MusubiPlayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Parsing Media PlayList(format: JSON)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        var musubiPlayerController:MusubiPlayerViewController = MusubiPlayerViewController()
        musubiPlayerController.mediaURL = "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"
        self.present(musubiPlayerController, animated: true, completion: nil)
    }
}

