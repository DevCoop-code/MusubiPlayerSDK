//
//  MusubiDevice.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/21.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

open class MusubiDeviceFactory {
    internal static var device: MusubiDevice?
    
    static func getMusubiDevice() -> MusubiDevice {
        if device == nil {
            device = MusubiDevice()
        }
        return device!
    }
}
