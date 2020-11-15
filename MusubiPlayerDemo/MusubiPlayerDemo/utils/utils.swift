//
//  utils.swift
//  MusubiPlayerDemo
//
//  Created by HanGyo Jeong on 2020/10/21.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import Foundation

enum musubiAction {
    case none
    case play
    case store
}

enum settingMode {
    case none
    case playerMode
}

enum videoPlayMode {
    case none
    case rawPlayer
    case viewController
}

struct mediaPlayList {
    var title: String
    var url: String
}

struct modeCellStruct {
    var title: String
    var mode: settingMode
}

protocol actionPopupDelegate: class {
    func didAction(action: musubiAction)
}

protocol settingDelegate: class {
    func musubiPlayerMode(onOff: Bool)
}
