//
//  switchCell.swift
//  MusubiPlayerDemo
//
//  Created by HanGyo Jeong on 2020/11/15.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

class switchCell: UITableViewCell {

    @IBOutlet weak var modeImage: UIImageView!
    @IBOutlet weak var modeName: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    var delegate: settingDelegate?
    
    @IBAction func playerModeSwitching(_ sender: Any) {
        let switchBtn = sender as! UISwitch
        NSLog("switch: \(switchBtn.isOn)")
        
        delegate?.musubiPlayerMode(onOff: switchBtn.isOn)
    }
}
