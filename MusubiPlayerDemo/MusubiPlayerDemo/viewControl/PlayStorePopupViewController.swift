//
//  PlayStorePopupViewController.swift
//  MusubiPlayerDemo
//
//  Created by HanGyo Jeong on 2020/10/21.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

class PlayStorePopupViewController: UIViewController {

    var action: musubiAction = .none
    var actionDelegate: actionPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playAction(_ sender: Any) {
        action = .play
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func storeAction(_ sender: Any) {
        action = .store
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        actionDelegate?.didAction(action: action)
        action = .none
    }
}
