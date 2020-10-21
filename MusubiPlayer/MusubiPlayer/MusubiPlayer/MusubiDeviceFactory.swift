//
//  MusubiDevice.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/21.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

open class MusubiDeviceFactory {
    static var device: MusubiDevice?
    
    open class var defaultDevice: MusubiDevice {
        if device == nil {
            device = MusubiDeviceImpl()
        }
        return device!
    }
//    public static func getMusubiDevice() -> MusubiDevice {
//        if device == nil {
//            device = MusubiDeviceImpl()
//        }
//        return device!
//    }
}
